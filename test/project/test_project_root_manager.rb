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

class Reality::Idea::TestProjectRootManager < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :project_root_manager,
                     Reality::Idea::Model::ProjectRootManager)

    assert_equal '1.8', project.project_root_manager.jdk_version
    project.project_root_manager.jdk_version = '1.6'
    assert_equal '1.6', project.project_root_manager.jdk_version
  end

  def test_bad_jdk_version
    project = create_project

    assert_idea_error('Component ProjectRootManager attempted to set invalid jdk_version to \'XXX\'. Valid values include: ["1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9"]') do
      project.project_root_manager.jdk_version = 'XXX'
    end
  end

  def test_build_xml
    project = create_project

    project.project_root_manager.jdk_version = '1.9'

    assert_xml_equal <<XML, component_to_xml(project.project_root_manager)
<component default="false" language_level="JDK_1_9" name="ProjectRootManager" project-jdk-name="1.9" project-jdk-type="JavaSDK" version="2">
  <output url="file://$PROJECT_DIR$/out"/>
</component>
XML
  end
end
