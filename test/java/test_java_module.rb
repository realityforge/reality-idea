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

class Reality::Idea::TestJavaModule < Reality::Idea::TestCase

  def test_idea_element_name
    project = create_project

    assert_equal([], project.plugin_dependencies.plugins)

    mod = Reality::Idea::Model::JavaModule.new(project, 'acal')

    assert_equal(%w(org.jetbrains.idea.maven).sort, project.plugin_dependencies.plugins.sort)

    assert_equal 'acal', mod.idea_element_name
    assert_equal 'acal.iml', mod.local_filename
    assert_equal "#{project.project_directory}/acal/acal.iml", mod.filename

    mod.module_directory = project.project_directory

    assert_equal "#{project.project_directory}/acal.iml", mod.filename
  end

  def test_to_xml_with_no_components
    mod = Reality::Idea::Model::JavaModule.new(create_project, 'acal')

    assert_xml_equal <<XML, mod.to_xml.to_s
<module type="JAVA_MODULE" relativePaths="true" version="4">
</module>
XML
  end

  def test_to_xml_with_components
    mod = Reality::Idea::Model::JavaModule.new(create_project, 'acal')

    mod.facets.gwt

    assert_xml_equal <<XML, mod.to_xml.to_s
<module relativePaths="true" type="JAVA_MODULE" version="4">
  <component name="FacetManager">
    <facet name="GWT" type="gwt">
      <configuration>
      </configuration>
    </facet>
  </component>
</module>
XML
  end
end
