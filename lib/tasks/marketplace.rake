require 'marketplace'
require 'byebug'
require 'rexml/document'
include REXML

namespace :marketplace do

    namespace :import do

        namespace :fhir do
        
            MARKETPLACE_IMPORT_ROOT = ENV['MARKETPLACE_IMPORT_ROOT']
            MARKETPLACE_IMPORT_OWNER_NAME = ENV['MARKETPLACE_IMPORT_OWNER_NAME']
            LOINC_LOGO = File.new(File.join(Rails.root, 'public', 'loinc-logo.png'))
            FHIR_MIME_TYPE = 'application/fhir+xml' # From: https://www.hl7.org/fhir/http.html


            def xml_to_product(xml_file)
                p = Product.new
                doc = Document.new(xml_file)
                # root = doc.root
                p = Product.where(
                    name: XPath.first(doc, '/StructureDefinition/name/@value').value).first_or_initialize
                p.attributes = {
                    description: XPath.first(doc, '/StructureDefinition/description/@value').value,
                    uri: XPath.first(doc, '/StructureDefinition/url/@value').value,
                    support_url: XPath.first(doc, '/StructureDefinition/url/@value').value,
                    logo: LOINC_LOGO,
                    mime_type: FHIR_MIME_TYPE
                    # name: XPath.first(doc, '/StructureDefinition/name/@value').value,
                }
                # puts p.to_json
                p
            end
            desc 'Import LOINC top 2K profiles as products.'

            task loinc2k: :environment do
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
                unless File.exist?(LOINC_LOGO)
                    puts "LOINC_LOGO must be the path to an image file."
                    exit 1
                end
                # puts LOINC_LOGO.to_path

                parent = Product.where(name: 'LOINC FHIR IG Profiles - Top 2K').first_or_initialize(
                    support_url: 'http://models.opencimi.org/ig/top-2k-loinc-lab-fhir-profiles/',
                    logo: LOINC_LOGO,
                    user: owner)
                parent.save!
                puts "Scanning..."
                imported = 0
                skipped = 0
                Dir.chdir(MARKETPLACE_IMPORT_ROOT)
                Dir.glob('*.xml') do |n|
                    product = xml_to_product File.open(n)
                    product.user = owner
                    # puts product.valid?
                    product.save!
                    sb = SubProduct.where(parent: parent, child: product).first_or_initialize
                    sb.save!
                    imported += 1
                rescue
                    puts product.to_json
                    byebug
                end
                puts "Done!"
                puts "\tImported: #{imported}"
                puts "\tSkipped: #{skipped}"
            end
        end
    end
end
