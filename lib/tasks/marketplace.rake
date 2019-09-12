# frozen_string_literal: true

require 'marketplace'
require 'byebug'
require 'rexml/document'
include REXML

namespace :marketplace do
  namespace :import do
    MARKETPLACE_IMPORT_ROOT = ENV['MARKETPLACE_IMPORT_ROOT']
    MARKETPLACE_IMPORT_OWNER_NAME = ENV['MARKETPLACE_IMPORT_OWNER_NAME']
    MARKETPLACE_IMPORT_LICENSE_NAME = ENV['MARKETPLACE_IMPORT_LICENSE_NAME']
    MARKETPLACE_IMPORT_META_LICENSE_NAME = ENV['MARKETPLACE_IMPORT_META_LICENSE_NAME']
    MARKETPLACE_IMPORT_IGNORE = ENV['MARKETPLACE_IMPORT_IGNORE'] ? ENV['MARKETPLACE_IMPORT_IGNORE'].split(',') : []

    def check_environment_variables
      unless MARKETPLACE_IMPORT_ROOT
        puts 'Please make sure MARKETPLACE_IMPORT_ROOT is set to the root directory of the content repository you want to import.'
        exit 1
      end
      unless File.directory?(MARKETPLACE_IMPORT_ROOT)
        puts 'MARKETPLACE_IMPORT_ROOT is not a directory.'
        exit 1
      end
      owner = User.where(name: MARKETPLACE_IMPORT_OWNER_NAME).first
      unless owner
        puts "User not found for name: #{MARKETPLACE_IMPORT_OWNER_NAME}"
        exit 1
      end
      owner
      end

    namespace :knart do
      MARKETPLACE_KNART_MANIFEST_FILE = 'manifest.json'
      MARKETPLACE_KNART_SUPPORT_URL = 'https://github.com/osehra/vha-kbs-knarts'
      MARKETPLACE_KNART_LOGO = File.new(File.join(Rails.root, 'public', 'va-seal-color.jpg'))
      MARKETPLACE_KNART_MIME_TYPE = 'application/x-knart'

      desc 'Upsert manifested HL7 Knowledge Artifacts'
      task manifest: :environment do
        owner = check_environment_variables
        manifest_file = File.join(MARKETPLACE_IMPORT_ROOT, MARKETPLACE_KNART_MANIFEST_FILE)
        unless File.exist?(manifest_file)
          puts "#{MARKETPLACE_KNART_MANIFEST_FILE} must exist at the root of MARKETPLACE_IMPORT_ROOT."
          exit 1
          end

        manifest = JSON.parse File.open(manifest_file, 'r').read
        # puts manifest
        meta = Product.where(name: manifest['name']).first_or_initialize
        meta.update(description: manifest['description'], support_url: MARKETPLACE_KNART_SUPPORT_URL,
                                                                         uri: 'knart://kbs.va.gov',
                                                                         published_at: Time.now,
                                                                         user: owner,
                                                                         mime_type: MARKETPLACE_KNART_MIME_TYPE)
        meta.logo.attach(io: MARKETPLACE_KNART_LOGO, filename: File.basename(MARKETPLACE_KNART_LOGO.path))
        MARKETPLACE_KNART_LOGO.rewind
        meta.save!

        if MARKETPLACE_IMPORT_META_LICENSE_NAME
          license = License.where(name: MARKETPLACE_IMPORT_META_LICENSE_NAME).first
          raise "Meta-license '#{MARKETPLACE_IMPORT_META_LICENSE_NAME}' not found." if license.nil?

          puts "Will use the #{license.name} license for the meta-product."
          pl = ProductLicense.where(product: meta, license: license).first_or_initialize
          pl.save!
        else
          puts 'Will not upsert licensing records for the meta-product.'
        end

        license = nil
        if MARKETPLACE_IMPORT_LICENSE_NAME
          license = License.where(name: MARKETPLACE_IMPORT_LICENSE_NAME).first
          raise "License '#{MARKETPLACE_IMPORT_LICENSE_NAME}' not found despite MARKETPLACE_IMPORT_LICENSE_NAME being set." if license.nil?

          puts "Will use the #{license.name} license for individual products."
        else
          puts 'Will not upsert licensing records for individual products.'
          end
        puts 'Now upserting KNARTs. This could take a while...'

        manifest['groups'].each do |g|
          g['items'].each do |i|
            mime = i['mimeType']
            next unless mime == 'application/hl7-cds-knowledge-artifact-1.3+xml' || mime == 'application/hl7-cds-knowledge-artifact-composite+xml'

            # There isn't an official MIME type, so this implementation just makes one up. :-/

            tags = i['tags'].join(',')
            name = "#{g['name']} #{i['name']}"
            name += " (#{tags})" unless tags.empty?

            puts "\t#{name}..."
            xml_file = File.join(MARKETPLACE_IMPORT_ROOT, i['path'])
            doc = Document.new(File.open(xml_file))
            # root = doc.root
            #
            rootNode = XPath.first(doc, '//knowledgeDocument') # || XPath.first(doc, '//compositeKnowledgeDocument')
            # byebug
            description = nil
            if tmp = XPath.first(rootNode, './metadata/description/@value')
                description = tmp.value
            end
            uri = nil
            if tmp = XPath.first(rootNode, './metadata/identifiers/identifier/@extension')
                uri = tmp.value 
            end
            p = Product.where(name: name).first_or_initialize
            p.update(
              description: description,
              uri: "knart://kbs.va.gov/#{uri}",
              support_url: MARKETPLACE_KNART_SUPPORT_URL,
              published_at: Time.now,
              user: owner,
              mime_type: MARKETPLACE_KNART_MIME_TYPE
            )
            p.logo.attach(io: MARKETPLACE_KNART_LOGO, filename: File.basename(MARKETPLACE_KNART_LOGO.path))
            MARKETPLACE_KNART_LOGO.rewind
            p.save!

            build = Build.where(product: p, version: 'latest').first_or_initialize
            build.asset.attach(io: File.new(xml_file), filename: "#{name}.xml")
            build.save!

            sp = SubProduct.where(parent_id: meta.id, child_id: p.id).first_or_initialize
            sp.save!

            if license
              pl = ProductLicense.where(product: p, license: license).first_or_initialize
              pl.save!
            end
            # puts p
          end
        end
      end
    end

    namespace :fhir do
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
        puts "No product name found for #{xml_file}!" unless name
        p = Product.where(name: name).first_or_initialize
        id = XPath.first(doc, '/StructureDefinition/id/@value').value
        p.attributes = {
          description: XPath.first(doc, '/StructureDefinition/description/@value').value,
          # uri: XPath.first(doc, '/StructureDefinition/url/@value').value,
          uri: "http://models.opencimi.org/ig/top-2k-loinc-lab-fhir-profiles/StructureDefinition-#{id}-definitions.html",
          support_url: LOINC_FHIR_SUPPORT_URL,
          mime_type: FHIR_MIME_TYPE,
          published_at: Time.now
          # name: XPath.first(doc, '/StructureDefinition/name/@value').value,
        }
        p.logo.attach(io: LOINC_FHIR_LOGO, filename: File.basename(LOINC_FHIR_LOGO.path))
        LOINC_FHIR_LOGO.rewind
        version = XPath.first(doc, '/StructureDefinition/date/@value').value
        [p, version]
      end

      desc 'Import LOINC top 2K profiles as products.'
      task loinc2k: :environment do
        owner = check_environment_variables
        unless File.exist?(LOINC_FHIR_LOGO)
          puts 'LOINC_FHIR_LOGO must be the path to an image file.'
          exit 1
        end

        parent = Product.where(name: LOINC_FHIR_META_PRODUCT_NAME).first_or_initialize(
          support_url: LOINC_FHIR_SUPPORT_URL,
          published_at: Time.now,
          user: owner
        )
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
          puts 'Will not upsert licensing records for the meta-product.'
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
          puts 'Will not upsert licensing records for individual products.'
        end
        puts 'Now importing all .xml files. This could take a while...'
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
              unless product.valid?
                puts 'Hmm.. product is present but not valid. This should never happen.'
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
        puts 'Done!'
        puts "Imported and/or Updated: #{imported.count}"
        puts "Skipped: #{skipped.count}"
        skipped.each do |n|
          puts "\t#{n}"
        end
      end
    end
  end
end
