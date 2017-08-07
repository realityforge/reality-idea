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
    project = create_project

    assert_equal([], project.plugin_dependencies.plugins)

    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_equal(%w(org.jetbrains.plugins.ruby).sort, project.plugin_dependencies.plugins.sort)

    assert_equal 'acal', mod.idea_element_name
    assert_equal 'acal.iml', mod.local_filename
    assert_equal "#{project.project_directory}/acal/acal.iml", mod.filename

    mod.module_directory = project.project_directory

    assert_equal "#{project.project_directory}/acal.iml", mod.filename
  end

  def test_try_load_ruby_version
    project = create_project

    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_nil mod.send(:try_load_ruby_version, mod.module_directory)

    FileUtils.mkdir_p project.project_directory
    IO.write("#{project.project_directory}/.ruby-version", "2.1.3\n")
    assert_nil mod.send(:try_load_ruby_version, mod.module_directory)

    FileUtils.mkdir_p mod.module_directory
    IO.write("#{mod.module_directory}/.ruby-version", "2.3\n")
    assert_equal '2.3', mod.send(:try_load_ruby_version, mod.module_directory)
  end

  def test_calculate_ruby_version
    project = create_project

    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_nil mod.send(:calculate_ruby_version)

    FileUtils.mkdir_p project.project_directory
    IO.write("#{project.project_directory}/.ruby-version", "2.1.3\n")
    assert_equal '2.1.3', mod.send(:calculate_ruby_version)

    FileUtils.mkdir_p mod.module_directory
    IO.write("#{mod.module_directory}/.ruby-version", "2.3\n")
    assert_equal '2.3', mod.send(:calculate_ruby_version)
  end

  def test_scan_gemfile_lock
    project = create_project

    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')
    mod.ruby_development_kit = '2.3.1'

    FileUtils.mkdir_p mod.module_directory
    File.write("#{mod.module_directory}/Gemfile.lock", <<CONTENT)
PATH
  remote: .
  specs:
    reality-idea (1.0.0)
      builder (= 3.2.2)
      reality-core (>= 1.8.0)
      reality-model (>= 1.3.0)

GEM
  remote: https://rubygems.org/
  specs:
    builder (3.2.2)
    mini_portile2 (2.1.0)
    minitest (5.9.1)
    nokogiri (1.7.2)
      mini_portile2 (~> 2.1.0)
    nokogiri-diff (0.2.0)
      nokogiri (~> 1.5)
      tdiff (~> 0.3, >= 0.3.2)
    power_assert (1.0.2)
    rake (0.9.2.2)
    reality-core (1.8.0)
    reality-model (1.3.0)
      reality-core (>= 1.8.0)
      reality-naming (>= 1.9.0)
      reality-orderedhash (>= 1.0.0)
    reality-naming (1.10.0)
    reality-orderedhash (1.0.0)
    tdiff (0.3.3)
    test-unit (3.1.5)
      power_assert

PLATFORMS
  ruby

DEPENDENCIES
  minitest (= 5.9.1)
  nokogiri (= 1.7.2)
  nokogiri-diff (= 0.2.0)
  rake (= 0.9.2.2)
  reality-idea!
  tdiff (= 0.3.3)
  test-unit (= 3.1.5)

BUNDLED WITH
   1.15.2
CONTENT

    assert_equal 0, mod.root_manager.order_entries.size

    mod.send(:scan_gemfile_lock!)

    assert_equal 14, mod.root_manager.order_entries.size

    assert_gem_order_entry(mod, 'builder', '3.2.2')
    assert_gem_order_entry(mod, 'mini_portile2', '2.1.0')
    assert_gem_order_entry(mod, 'minitest', '5.9.1')
    assert_gem_order_entry(mod, 'nokogiri', '1.7.2')
    assert_gem_order_entry(mod, 'nokogiri-diff', '0.2.0')
    assert_gem_order_entry(mod, 'power_assert', '1.0.2')
    assert_gem_order_entry(mod, 'rake', '0.9.2.2')
    assert_gem_order_entry(mod, 'reality-core', '1.8.0')
    assert_gem_order_entry(mod, 'reality-idea', '1.0.0')
    assert_gem_order_entry(mod, 'reality-model', '1.3.0')
    assert_gem_order_entry(mod, 'reality-naming', '1.10.0')
    assert_gem_order_entry(mod, 'reality-orderedhash', '1.0.0')
    assert_gem_order_entry(mod, 'tdiff', '0.3.3')
    assert_gem_order_entry(mod, 'test-unit', '3.1.5')
  end

  def assert_gem_order_entry(mod, name, version)
    assert_true mod.root_manager.order_entries.any? {|e| e.is_a?(Reality::Idea::Model::GemOrderEntry) && e.name == name && e.version.to_s == version}
  end

  def test_ruby_development_kit
    project = create_project

    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_idea_error('Unable to determine ruby_development_kit for module acal') do
      mod.ruby_development_kit
    end

    FileUtils.mkdir_p project.project_directory
    IO.write("#{project.project_directory}/.ruby-version", "2.1.3\n")
    assert_equal '2.1.3', mod.ruby_development_kit

    mod.ruby_development_kit = nil
    FileUtils.mkdir_p mod.module_directory
    IO.write("#{mod.module_directory}/.ruby-version", "2.3\n")
    assert_equal '2.3', mod.ruby_development_kit

    mod.ruby_development_kit = '2.42'
    assert_equal '2.42', mod.ruby_development_kit
  end

  def test_to_xml_with_no_explicit_components
    mod = Reality::Idea::Model::RubyModule.new(create_project, 'acal')

    assert_xml_equal <<XML, mod.to_xml.to_s
<module type="RUBY_MODULE" version="4">
  <component inherit-compiler-output="true" name="NewModuleRootManager">
    <exclude-output/>
    <orderEntry forTests="false" type="sourceFolder"/>
  </component>
</module>
XML
  end

  def test_to_xml_with_components
    mod = Reality::Idea::Model::RubyModule.new(create_project, 'acal')

    mod.settings.load_path << "#{mod.module_directory}/lib"
    mod.settings.load_path << "#{mod.module_directory}/test"

    assert_xml_equal <<XML, mod.to_xml.to_s
<module type="RUBY_MODULE" version="4">
  <component inherit-compiler-output="true" name="NewModuleRootManager">
    <exclude-output/>
    <orderEntry forTests="false" type="sourceFolder"/>
  </component>
  <component name="RModuleSettingsStorage">
    <LOAD_PATH number="2" string0="$MODULE_DIR$/lib" string1="$MODULE_DIR$/test"/>
    <I18N_FOLDERS number="0"/>
  </component>
</module>
XML
  end

  def test_to_xml_when_scanning_filesystem
    project = create_project

    FileUtils.mkdir_p "#{project.project_directory}/acal"
    IO.write("#{project.project_directory}/acal/.ruby-version", "2.3\n")
    File.write("#{project.project_directory}/acal/Gemfile.lock", <<CONTENT)
PATH
  remote: .
  specs:
    reality-idea (1.0.0)
      builder (= 3.2.2)
      reality-core (>= 1.8.0)
      reality-model (>= 1.3.0)

GEM
  remote: https://rubygems.org/
  specs:
    builder (3.2.2)
    mini_portile2 (2.1.0)
    minitest (5.9.1)
    nokogiri (1.7.2)
      mini_portile2 (~> 2.1.0)
    nokogiri-diff (0.2.0)
      nokogiri (~> 1.5)
      tdiff (~> 0.3, >= 0.3.2)
    power_assert (1.0.2)
    rake (0.9.2.2)
    reality-core (1.8.0)
    reality-model (1.3.0)
      reality-core (>= 1.8.0)
      reality-naming (>= 1.9.0)
      reality-orderedhash (>= 1.0.0)
    reality-naming (1.10.0)
    reality-orderedhash (1.0.0)
    tdiff (0.3.3)
    test-unit (3.1.5)
      power_assert

PLATFORMS
  ruby

DEPENDENCIES
  minitest (= 5.9.1)
  nokogiri (= 1.7.2)
  nokogiri-diff (= 0.2.0)
  rake (= 0.9.2.2)
  reality-idea!
  tdiff (= 0.3.3)
  test-unit (= 3.1.5)

BUNDLED WITH
   1.15.2
CONTENT

    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    mod.settings.load_path << "#{mod.module_directory}/lib"
    mod.settings.load_path << "#{mod.module_directory}/test"

    assert_xml_equal <<XML, mod.to_xml.to_s
<module type="RUBY_MODULE" version="4">
  <component inherit-compiler-output="true" name="NewModuleRootManager">
    <exclude-output/>
    <orderEntry jdkName="2.3" jdkType="RUBY_SDK" type="jdk"/>
    <orderEntry forTests="false" type="sourceFolder"/>
    <orderEntry level="application" name="builder (v3.2.2, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="mini_portile2 (v2.1.0, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="minitest (v5.9.1, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="nokogiri (v1.7.2, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="nokogiri-diff (v0.2.0, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="power_assert (v1.0.2, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="rake (v0.9.2.2, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="reality-core (v1.8.0, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="reality-idea (v1.0.0, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="reality-model (v1.3.0, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="reality-naming (v1.10.0, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="reality-orderedhash (v1.0.0, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="tdiff (v0.3.3, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
    <orderEntry level="application" name="test-unit (v3.1.5, rbenv: 2.3) [gem]" scope="PROVIDED" type="library"/>
  </component>
  <component name="RModuleSettingsStorage">
    <LOAD_PATH number="2" string0="$MODULE_DIR$/lib" string1="$MODULE_DIR$/test"/>
    <I18N_FOLDERS number="0"/>
  </component>
</module>
XML
  end
end
