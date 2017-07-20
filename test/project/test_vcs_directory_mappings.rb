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

class Reality::Idea::TestVcsDirectoryMappings < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :vcs_directory_mappings,
                     Reality::Idea::Model::VcsDirectoryMappings)

    assert_equal({}, project.vcs_directory_mappings.mappings)

    project.vcs_directory_mappings.add('FOO', project.project_directory)
    assert_equal({ 'FOO' => project.project_directory }, project.vcs_directory_mappings.mappings)

    project.vcs_directory_mappings.add_git("#{project.project_directory}/dir1")
    assert_equal({ 'FOO' => project.project_directory, 'Git' => "#{project.project_directory}/dir1" }, project.vcs_directory_mappings.mappings)

    project.vcs_directory_mappings.add_svn("#{project.project_directory}/dir2")
    assert_equal({ 'FOO' => project.project_directory, 'Git' => "#{project.project_directory}/dir1", 'svn' => "#{project.project_directory}/dir2" }, project.vcs_directory_mappings.mappings)
  end

  def test_to_xml
    project = create_project

    project.vcs_directory_mappings.add('Other',"#{project.project_directory}")
    project.vcs_directory_mappings.add_git("#{project.project_directory}/vendor/dir1")
    project.vcs_directory_mappings.add_svn("#{project.project_directory}/vendor/dir2")

    assert_xml_equal <<XML, project.vcs_directory_mappings.to_xml.to_s
<component name="VcsDirectoryMappings">
  <mapping directory="$PROJECT_DIR$" vcs="Other"/>
  <mapping directory="$PROJECT_DIR$/vendor/dir1" vcs="Git"/>
  <mapping directory="$PROJECT_DIR$/vendor/dir2" vcs="svn"/>
</component>
XML
  end

  def test_detect_vcs
    project = create_project
    assert_equal 0, project.vcs_directory_mappings.mappings.size
  end

  def test_detect_vcs_git
    project = create_project
    FileUtils.mkdir_p "#{project.project_directory}/.git"
    assert_equal 1, project.vcs_directory_mappings.mappings.size
    assert_equal 'Git', project.vcs_directory_mappings.mappings.keys[0]
    assert_equal project.project_directory, project.vcs_directory_mappings.mappings.values[0]
  end

  def test_detect_vcs_svn
    project = create_project
    FileUtils.mkdir_p "#{project.project_directory}/.svn"
    assert_equal 1, project.vcs_directory_mappings.mappings.size
    assert_equal 'svn', project.vcs_directory_mappings.mappings.keys[0]
    assert_equal project.project_directory, project.vcs_directory_mappings.mappings.values[0]
  end
end
