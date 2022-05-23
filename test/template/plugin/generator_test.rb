# frozen_string_literal: true

require 'minitest/autorun'
require 'active_support/testing/assertions'
require_relative '../../../template/plugin/generator'

module Web
  module Template
    module Plugin
      class GeneratorTest < Minitest::Test
        include ActiveSupport::Testing::Assertions

        def setup
          root_path = File.expand_path("#{__dir__}/../../..")
          @component_name = 'generated_component'
          @component_path = "#{root_path}/test/tmp/#{component_name}"

          create_folders
        end

        def teardown
          FileUtils.remove_dir(component_path, true)
        end

        attr_reader :component_name, :component_path

        def generator
          @generator ||= Web::Template::Plugin::Generator.new(component_name, component_path)
        end

        def test_call
          assert generator.call

          assert_generated_files
        end

        def assert_generated_files
          generator.file_paths.each do |file_data|
            path_dest = "#{component_path}/#{file_data[:file_destination]}"
            path_template = "#{Generator::GENERATOR_PATH}/#{file_data[:file_template]}"
            assert_equal erb_content(path_template), File.read(path_dest)
          end
        end

        def erb_content(path)
          namespace_binding = generator.namespace.namespace_binding
          ERB.new(File.read(path)).result(namespace_binding)
        end

        def create_folders
          ["lib/#{component_name}", 'scripts', 'bin', 'test'].each do |relative_path|
            FileUtils.mkdir_p "#{component_path}/#{relative_path}"
          end
        end
      end
    end
  end
end
