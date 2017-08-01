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

class Reality::Idea::TestArtifacts < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :artifacts,
                     Reality::Idea::Model::Artifacts)

    assert_equal(0, project.artifacts.artifacts.size)
  end

  def test_build_xml_empty
    project = create_project

    assert_xml_equal <<XML, component_to_xml(project.artifacts)
<component name="ArtifactManager">
</component>
XML
  end

  def test_build_xml_single_artifact
    project = create_project

    project.artifacts.jar('foo')

    assert_xml_equal <<XML, component_to_xml(project.artifacts)
<component name="ArtifactManager">
  <artifact build-on-make="false" name="foo" type="jar">
    <output-path>$PROJECT_DIR$/artifacts/foo</output-path>
    <root id="archive" name="foo.jar">
    </root>
  </artifact>
</component>
XML
  end

  def test_build_xml_multiple_artifacts
    project = create_project

    project.artifacts.jar('foo')
    project.artifacts.jar('bar')

    assert_xml_equal <<XML, component_to_xml(project.artifacts)
<component name="ArtifactManager">
  <artifact build-on-make="false" name="foo" type="jar">
    <output-path>$PROJECT_DIR$/artifacts/foo</output-path>
    <root id="archive" name="foo.jar">
    </root>
  </artifact>
  <artifact build-on-make="false" name="bar" type="jar">
    <output-path>$PROJECT_DIR$/artifacts/bar</output-path>
    <root id="archive" name="bar.jar">
    </root>
  </artifact>
</component>
XML
  end
end
