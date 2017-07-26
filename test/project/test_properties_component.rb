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

class Reality::Idea::TestPropertiesComponent < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :properties,
                     Reality::Idea::Model::PropertiesComponent)

    assert_equal({}, project.properties.properties)

    project.properties.set('nodejs_interpreter_path', '/usr/local/bin/node')
    assert_equal({ 'nodejs_interpreter_path' => '/usr/local/bin/node' }, project.properties.properties)

    project.properties.set('GoToClass.includeLibraries', 'true')
    assert_equal({
                   'GoToClass.includeLibraries' => 'true',
                   'nodejs_interpreter_path' => '/usr/local/bin/node'
                 },
                 project.properties.properties)

    project.properties.set('nodejs_interpreter_path', '$USER_HOME$/.nodenv/versions/6.10.3/bin/node')
    assert_equal({
                   'GoToClass.includeLibraries' => 'true',
                   'nodejs_interpreter_path' => '$USER_HOME$/.nodenv/versions/6.10.3/bin/node'
                 },
                 project.properties.properties)
  end

  def test_build_xml
    project = create_project

    project.properties.set('nodejs_interpreter_path', '$USER_HOME$/.nodenv/versions/6.10.3/bin/node')

    assert_xml_equal <<XML, component_to_xml(project.properties)
<component name="PropertiesComponent">
  <property name="nodejs_interpreter_path" value="$USER_HOME$/.nodenv/versions/6.10.3/bin/node"/>
</component>
XML
  end
end
