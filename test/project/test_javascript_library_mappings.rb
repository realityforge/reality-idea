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

class Reality::Idea::TestJavascriptLibraryMappings < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_equal([], project.plugin_dependencies.plugins)

    assert_component(project,
                     :javascript_library_mappings,
                     Reality::Idea::Model::JavaScriptLibraryMappings)

    assert_equal(%w(JavaScript NodeJS).sort, project.plugin_dependencies.plugins.sort)

    assert_equal 0, project.javascript_library_mappings.predefined_libraries.size

    project.javascript_library_mappings.add_nodejs_predefined_library
    project.javascript_library_mappings.add_predefined_library('Foo')

    assert_equal ['Node.js Core', 'Foo'], project.javascript_library_mappings.predefined_libraries
  end

  def test_build_xml
    project = create_project

    project.javascript_library_mappings.add_nodejs_predefined_library

    assert_xml_equal <<XML, component_to_xml(project.javascript_library_mappings)
<component name="JavaScriptLibraryMappings">
  <includedPredefinedLibrary name="Node.js Core" />
</component>
XML
  end
end
