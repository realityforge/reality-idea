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

require File.expand_path('../../helper', __FILE__)

class Reality::Idea::TestRubyModule < Reality::Idea::TestCase

  def test_idea_element_name
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal')
    project.project_directory = local_dir
    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_equal 'acal', mod.idea_element_name
    assert_equal 'acal.iml', mod.local_filename
    assert_equal "#{local_dir}/acal/acal.iml", mod.filename

    mod.module_directory = local_dir

    assert_equal "#{local_dir}/acal.iml", mod.filename
  end

  def test_try_load_ruby_version
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal')
    project.project_directory = local_dir
    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_nil mod.send(:try_load_ruby_version, mod.module_directory)

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/.ruby-version", "2.1.3\n")
    assert_nil mod.send(:try_load_ruby_version, mod.module_directory)

    FileUtils.mkdir_p mod.module_directory
    IO.write("#{mod.module_directory}/.ruby-version", "2.3\n")
    assert_equal '2.3', mod.send(:try_load_ruby_version, mod.module_directory)
  end

  def test_calculate_ruby_version
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal')
    project.project_directory = local_dir
    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_nil mod.send(:calculate_ruby_version)

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/.ruby-version", "2.1.3\n")
    assert_equal '2.1.3', mod.send(:calculate_ruby_version)

    FileUtils.mkdir_p mod.module_directory
    IO.write("#{mod.module_directory}/.ruby-version", "2.3\n")
    assert_equal '2.3', mod.send(:calculate_ruby_version)
  end

  def test_ruby_development_kit
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal')
    project.project_directory = local_dir
    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_idea_error('Unable to determine ruby_development_kit for module acal') do
      mod.ruby_development_kit
    end

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/.ruby-version", "2.1.3\n")
    assert_equal '2.1.3', mod.ruby_development_kit

    mod.ruby_development_kit = nil
    FileUtils.mkdir_p mod.module_directory
    IO.write("#{mod.module_directory}/.ruby-version", "2.3\n")
    assert_equal '2.3', mod.ruby_development_kit

    mod.ruby_development_kit = '2.42'
    assert_equal '2.42', mod.ruby_development_kit
  end

  def test_to_xml_with_no_components
    mod = Reality::Idea::Model::RubyModule.new(create_project, 'acal')

    assert_xml_equal <<XML, mod.to_xml.to_s
<module type="RUBY_MODULE" version="4">
</module>
XML
  end

  def test_to_xml_with_components
    mod = Reality::Idea::Model::RubyModule.new(create_project, 'acal')

    mod.settings.load_path << "#{mod.module_directory}/lib"
    mod.settings.load_path << "#{mod.module_directory}/test"

    assert_xml_equal <<XML, mod.to_xml.to_s
<module type="RUBY_MODULE" version="4">
  <component name="RModuleSettingsStorage">
    <LOAD_PATH number="2" string0="$MODULE_DIR$/lib" string1="$MODULE_DIR$/test"/>
    <I18N_FOLDERS number="0"/>
  </component>
</module>
XML
  end
end
