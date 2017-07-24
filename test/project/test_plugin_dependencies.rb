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

class Reality::Idea::TestPluginDependencies < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :plugin_dependencies,
                     Reality::Idea::Model::PluginDependencies)

    assert_equal [], project.plugin_dependencies.plugins
    project.plugin_dependencies.add('GlassFish')
    project.plugin_dependencies.add('com.intellij.gwt')

    assert_equal %w(GlassFish com.intellij.gwt), project.plugin_dependencies.plugins
  end

  def test_to_xml
    project = create_project

    project.plugin_dependencies.add('com.intellij.gwt')
    project.plugin_dependencies.add('GlassFish')

    assert_xml_equal <<XML, project.plugin_dependencies.to_xml.to_s
<component name="ExternalDependencies">
  <plugin id="GlassFish"/>
  <plugin id="com.intellij.gwt"/>
</component>
XML
  end
end
