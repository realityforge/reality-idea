#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$:.unshift File.expand_path('../../lib', __FILE__)

require 'securerandom'
require 'minitest/autorun'
require 'test/unit/assertions'
require 'reality/idea'
require 'nokogiri/diff'

module Reality::Idea
  class << self
    def reset
      self.send(:project_map).clear
    end
  end
end

class Reality::Idea::TestCase < Minitest::Test
  include Test::Unit::Assertions
  include Reality::Logging::Assertions

  def setup
    Reality::Idea.reset
    self.setup_working_dir
  end

  def teardown
    Reality::Idea.reset
    self.teardown_working_dir
  end

  def setup_working_dir
    @cwd = Dir.pwd

    FileUtils.mkdir_p self.working_dir
    Dir.chdir(self.working_dir)
  end

  def teardown_working_dir
    Dir.chdir(@cwd)
    if passed?
      FileUtils.rm_rf self.working_dir if File.exist?(self.working_dir)
    else
      $stderr.puts "Test #{self.class.name}.#{name} Failed. Leaving working directory #{self.working_dir}"
    end
  end

  def random_local_dir
    local_dir(random_string)
  end

  def local_dir(directory)
    "#{working_dir}/#{directory}"
  end

  def working_dir
    @working_dir ||= "#{workspace_dir}/#{self.class.name.gsub(/[\.\:]/, '_')}_#{name}_#{::SecureRandom.hex}"
  end

  def workspace_dir
    @workspace_dir ||= File.expand_path(ENV['TEST_TMP_DIR'] || "#{File.dirname(__FILE__)}/../tmp/workspace")
  end

  def assert_idea_error(expected_message, &block)
    assert_logging_error(Reality::Idea, expected_message) do
      yield block
    end
  end

  def assert_component(component_container, key, expected_type)
    assert_equal component_container.components.size, 0
    component = component_container.send(key)
    assert_equal true, component.singleton_class.include?(expected_type)
    assert_equal component_container.components.size, 1
    assert_equal component, component_container.send(key)
    assert_equal component_container.components.size, 1

    yield component if block_given?
    component
  end

  def assert_xml_equal(expected_xml, actual_xml)
    expected_doc = Nokogiri::XML(expected_xml)
    actual_doc = Nokogiri::XML(actual_xml)

    unless expected_doc.tdiff_equal(actual_doc)
      lines = ''
      failed = false
      expected_doc.diff(actual_doc) do |change, node|
        failed = true if change.strip != ''
        lines += "#{change} #{node.to_xml}".ljust(30) + "#{node.parent.path}\n"
      end
      fail "Unexpected diff between two documents.\n\n#{lines}\n\nActual:#{actual_doc}" if failed
    end
  end

  def random_string
    ::SecureRandom.hex
  end

  def create_project(options = {}, &block)
    name = options[:name] || self.random_string
    project_directory = options[:project_directory] || self.random_local_dir
    Reality::Idea::Model::Project.new(name, :project_directory => project_directory, &block)
  end
end
