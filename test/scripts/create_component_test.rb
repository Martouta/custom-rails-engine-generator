# frozen_string_literal: true

require 'minitest/autorun'
require 'active_support/testing/assertions'

module Scripts
  class CreateComponentTest < Minitest::Test
    include ActiveSupport::Testing::Assertions

    def setup
      root_path = File.expand_path("#{__dir__}/../..")
      @component_name = 'generated_component'
      @component_path = "#{root_path}/test/tmp/#{component_name}"
    end

    def teardown
      FileUtils.remove_dir(component_path, true)
    end

    attr_reader :component_name, :component_path

    def test_create_component_runs_successfully
      assert system("./scripts/create_component.sh #{component_name} #{component_path} >/dev/null 2>&1")
      assert File.exist?("#{component_path}/lib/#{component_name}.rb")
    end

    def test_create_invalid_component_returns_failure
      refute system('./scripts/create_component.sh 111invalid >/dev/null 2>&1')
      refute File.directory?(component_path)
    end
  end
end
