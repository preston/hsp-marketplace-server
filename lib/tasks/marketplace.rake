require 'marketplace'
require 'byebug'
require 'rexml/document'
include REXML

namespace :marketplace do

    namespace :import do

        namespace :fhir do

            MARKETPLACE_IMPORT_ROOT = ENV['MARKETPLACE_IMPORT_ROOT']
            MARKETPLACE_IMPORT_OWNER_NAME = ENV['MARKETPLACE_IMPORT_OWNER_NAME']
            MARKETPLACE_IMPORT_LICENSE_NAME = ENV['MARKETPLACE_IMPORT_LICENSE_NAME']
            MARKETPLACE_IMPORT_META_LICENSE_NAME = ENV['MARKETPLACE_IMPORT_META_LICENSE_NAME']
            MARKETPLACE_IMPORT_IGNORE = ENV['MARKETPLACE_IMPORT_IGNORE'] ? ENV['MARKETPLACE_IMPORT_IGNORE'].split(',') : []

            # LOINC_LOGO = File.new(File.join(Rails.root, 'public', 'loinc-logo.png'))
            LOINC_FHIR_LOGO = File.new(File.join(Rails.root, 'public', 'loinc-on-fhir-with-alpha.png'))
            LOINC_FHIR_META_PRODUCT_NAME = ENV['LOINC_FHIR_META_PRODUCT_NAME'] || 'LOINC FHIR IG Profiles - Top 2K'
            LOINC_FHIR_SUPPORT_URL = 'http://models.opencimi.org/ig/top-2k-loinc-lab-fhir-profiles/'

            FHIR_MIME_TYPE = 'application/fhir+xml' # From: https://www.hl7.org/fhir/http.html


            def xml_to_product(xml_file)
                doc = Document.new(xml_file)
                # root = doc.root
                # byebug
                if XPath.first(doc, '//StructureDefinition').nil?
                    return nil # Not interested!
                end
                name = XPath.first(doc, '/StructureDefinition/name/@value').value
                puts "No product name found for #{xml_file.to_s}!" unless name
                p = Product.where(name: name).first_or_initialize
                p.attributes = {
                    description: XPath.first(doc, '/StructureDefinition/description/@value').value,
                    uri: XPath.first(doc, '/StructureDefinition/url/@value').value,
                    support_url: LOINC_FHIR_SUPPORT_URL,
                    mime_type: FHIR_MIME_TYPE,
                    published_at: Time.now
                    # name: XPath.first(doc, '/StructureDefinition/name/@value').value,
                }
                p.logo.attach(io: LOINC_FHIR_LOGO, filename: File.basename(LOINC_FHIR_LOGO.path))
                LOINC_FHIR_LOGO.rewind
                version = XPath.first(doc, '/StructureDefinition/date/@value').value
                return p, version
            end

 

            desc 'Import LOINC top 2K profiles as products.'
            task loinc2k: :environment do
                owner = check_environment_variables
                unless File.exist?(LOINC_FHIR_LOGO)
                    puts "LOINC_FHIR_LOGO must be the path to an image file."
                    exit 1
                end

                parent = Product.where(name: LOINC_FHIR_META_PRODUCT_NAME).first_or_initialize(
                    support_url: LOINC_FHIR_SUPPORT_URL,
                    published_at: Time.now,
                    user: owner)
                parent.logo.attach(io: LOINC_FHIR_LOGO, filename: File.basename(LOINC_FHIR_LOGO.path))
                LOINC_FHIR_LOGO.rewind
                parent.save!
                if MARKETPLACE_IMPORT_META_LICENSE_NAME
                    license = License.where(name: MARKETPLACE_IMPORT_META_LICENSE_NAME).first
                    raise "Meta-license '#{MARKETPLACE_IMPORT_META_LICENSE_NAME}' not found." if license.nil?
                    puts "Will use the #{license.name} license for the meta-product."
                    pl = ProductLicense.where(product: parent, license: license).first_or_initialize
                    pl.save!
                else
                    puts "Will not upsert licensing records for the meta-product."
                end

                import_structure_definitions(owner, parent)
            end

            desc 'Import LOINC top 2K profiles as products.'
            task structuredefinition: :environment do
                owner = check_environment_variables
                import_structure_definitions owner

            end

            def import_structure_definitions(owner, parent = nil)
                license = nil
                if MARKETPLACE_IMPORT_LICENSE_NAME
                    license = License.where(name: MARKETPLACE_IMPORT_LICENSE_NAME).first
                    raise "License '#{MARKETPLACE_IMPORT_LICENSE_NAME}' not found." if license.nil?
                    puts "Will use the #{license.name} license for individual products."
                else
                    puts "Will not upsert licensing records for individual products."
                end
                puts "Now importing all .xml files. This could take a while..."
                imported = []
                skipped = []
                Dir.chdir(MARKETPLACE_IMPORT_ROOT)
                Dir.glob('*.xml') do |n|
                    if MARKETPLACE_IMPORT_IGNORE.include? n
                        puts "\tSkipping ignored file: #{n}"
                        skipped << n
                    else
                        puts "\tProcessing: #{n}"
                        product, version = xml_to_product(File.open(n))
                        # byebug
                        if product.nil?
                            puts "\tSkipping non-StructureDefinition file: #n"
                            skipped << n
                        else
                            product.user = owner
                            if !product.valid?
                                puts "Hmm.. product is present but not valid. This should never happen."
                                # byebug
                            end
                            product.save!
                            build = Build.where(product: product, version: version).first_or_initialize
                            build.asset.attach(io: File.new(n), filename: n)
                            build.save!
                            if license
                                pl = ProductLicense.where(product: product, license: license).first_or_initialize
                                pl.save!
                            end
                            if parent
                                sb = SubProduct.where(parent_id: parent.id, child_id: product.id).first_or_initialize
                                # byebug
                                sb.save!
                            end
                            imported << n
                            # begin
                            # rescue Exception => e
                            #     puts "Exception thrown for product: #{product.to_json}"
                            #     byebug
                            # end
                            # skipped += 1
                        end
                    end
                end
                puts "Done!"
                puts "Imported and/or Updated: #{imported.count}"
                puts "Skipped: #{skipped.count}"
                skipped.each do |n| 
                    puts "\t#{n}"
                end
            end

            def check_environment_variables
                unless MARKETPLACE_IMPORT_ROOT
                    puts "Please make sure MARKETPLACE_IMPORT_ROOT is set to the root directory of the content repository you want to import."
                    exit 1
                end
                unless File.directory?(MARKETPLACE_IMPORT_ROOT)
                    puts "MARKETPLACE_IMPORT_ROOT is not a directory."
                    exit 1
                end
                unless MARKETPLACE_IMPORT_ROOT
                    puts 'MARKETPLACE_IMPORT_ROOT must be set.'
                    exit 1
                end
                owner = User.where(name: MARKETPLACE_IMPORT_OWNER_NAME).first
                unless owner
                    puts "User not found for name: #{MARKETPLACE_IMPORT_OWNER_NAME}"
                    exit 1
                end
                owner
            end

        end
    end
end
