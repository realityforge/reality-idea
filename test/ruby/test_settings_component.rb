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

class Reality::Idea::TestSettingsComponent < Reality::Idea::TestCase
  def test_settings
    project = Reality::Idea::Model::Project.new('acal', :project_directory => self.random_local_dir)
    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    assert_equal mod.components.size, 0
    assert_equal mod.settings.load_path, []
    assert_equal mod.components.size, 1
    assert_equal mod.settings.load_path, []
    assert_equal mod.components.size, 1

    mod.settings.load_path << "#{mod.module_directory}/lib"
    mod.settings.load_path << "#{mod.module_directory}/test"
    mod.settings.load_path << "#{mod.module_directory}/spec"

    assert_equal mod.settings.load_path, %W(#{mod.module_directory}/lib #{mod.module_directory}/test #{mod.module_directory}/spec)
  end

  def test_to_xml
    project = Reality::Idea::Model::Project.new('acal', :project_directory => self.random_local_dir)
    mod = Reality::Idea::Model::RubyModule.new(project, 'acal')

    mod.settings.load_path << "#{mod.module_directory}/lib"
    mod.settings.load_path << "#{mod.module_directory}/test"

    assert_equal <<XML.strip, mod.settings.to_xml.to_s
<component name="RModuleSettingsStorage">
  <LOAD_PATH number="2" string0="$MODULE_DIR$/lib" string1="$MODULE_DIR$/test"/>
  <I18N_FOLDERS number="0"/>
</component>
XML
  end
end
