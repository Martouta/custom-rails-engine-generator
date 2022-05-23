# frozen_string_literal: true

require 'erb'
require 'active_support/inflector'

module Web
  module Template
    module Plugin
      class Generator
        GENERATOR_PATH = __dir__

        class Namespace
          def initialize(hash)
            hash.each do |key, value|
              singleton_class.send(:define_method, key) { value }
            end
          end

          def namespace_binding
            binding
          end
        end

        def initialize(component_name, component_path)
          @component_name = component_name
          @component_path = component_path
          @namespace = Namespace.new(name: component_name)
        end

        attr_reader :component_name, :component_path, :namespace

        def call!
          file_paths.each do |file_content|
            file_template = File.read("#{GENERATOR_PATH}/#{file_content[:file_template]}")
            erb = ERB.new(file_template).result(namespace.namespace_binding)
            File.write("#{component_path}/#{file_content[:file_destination]}", erb)
          end
        end

        def call
          call! and return true
        rescue Errno::ENOENT, IOError, Errno::EACCES
          false
        end

        DEFAULT_FILE_PATHS = [
          { file_template: 'script_test.erb', file_destination: 'scripts/test.sh' },
          { file_template: 'script_quality.erb', file_destination: 'scripts/quality.sh' },
          { file_template: 'gitignore.erb', file_destination: '.gitignore' },
          { file_template: 'gemfile.erb', file_destination: 'Gemfile' },
          { file_template: 'bin_rails.erb', file_destination: 'bin/rails' },
          { file_template: 'rakefile.erb', file_destination: 'Rakefile' },
          { file_template: 'test_helper.erb', file_destination: 'test/test_helper.rb' }
        ].freeze

        def file_paths
          DEFAULT_FILE_PATHS + [
            { file_template: 'version.erb',
              file_destination: "lib/#{component_name}/version.rb" },
            { file_template: 'gemspec.erb',
              file_destination: "#{component_name}.gemspec" },
            { file_template: 'engine.erb',
              file_destination: "lib/#{component_name}/engine.rb" },
            { file_template: 'lib_component_file.erb',
              file_destination: "lib/#{component_name}.rb" }
          ]
        end
      end
    end
  end
end
