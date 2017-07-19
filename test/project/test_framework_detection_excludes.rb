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

class Reality::Idea::TestFrameworkDetectionExcludes < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :framework_detection_excludes,
                     Reality::Idea::Model::FrameworkDetectionExcludes)

    assert_equal [], project.framework_detection_excludes.paths
    project.framework_detection_excludes.paths << "#{project.project_directory}/artifacts"
    project.framework_detection_excludes.paths << "#{project.project_directory}/reports"
    project.framework_detection_excludes.paths << "#{project.project_directory}/target"
    project.framework_detection_excludes.paths << "#{project.project_directory}/tmp"


    assert_equal %W(#{project.project_directory}/artifacts #{project.project_directory}/reports #{project.project_directory}/target #{project.project_directory}/tmp),
                 project.framework_detection_excludes.paths
  end

  def test_to_xml
    project = create_project

    project.framework_detection_excludes.paths << "#{project.project_directory}/artifacts"
    project.framework_detection_excludes.paths << "#{project.project_directory}/target"
    project.framework_detection_excludes.paths << "#{project.project_directory}/tmp"

    assert_equal <<XML.strip, project.framework_detection_excludes.to_xml.to_s
<component name="FrameworkDetectionExcludesConfiguration">
  <file url="file://$PROJECT_DIR$/artifacts"/>
  <file url="file://$PROJECT_DIR$/target"/>
  <file url="file://$PROJECT_DIR$/tmp"/>
</component>
XML
  end
end
