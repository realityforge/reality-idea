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

class Reality::Idea::TestJavascriptSettings < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_equal([], project.plugin_dependencies.plugins)

    assert_component(project,
                     :javascript_settings,
                     Reality::Idea::Model::JavaScriptSettings)

    assert_equal(%w(JavaScript NodeJS).sort, project.plugin_dependencies.plugins.sort)

    assert_equal 'ES6', project.javascript_settings.language_level
    project.javascript_settings.language_level = 'JSX'
    assert_equal 'JSX', project.javascript_settings.language_level
  end

  def test_build_xml
    project = create_project

    project.javascript_settings.language_level = 'JSX'

    assert_xml_equal <<XML, component_to_xml(project.javascript_settings)
<component name="JavaScriptSettings">
  <option name="languageLevel" value="JSX" />
</component>
XML
  end
end
