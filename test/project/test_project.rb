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

class Reality::Idea::TestProject < Reality::Idea::TestCase

  def test_idea_element_name
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal')
    assert_idea_error('Project acal has not specified a project_directory') do
      project.project_directory
    end
    project.project_directory = local_dir

    assert_equal 'acal', project.idea_element_name
    assert_equal 'acal.ipr', project.local_filename
    assert_equal "#{local_dir}/acal.ipr", project.filename
  end

  def test_idea_element_name_with_prefix_and_suffix
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal')
    project.project_directory = local_dir
    project.prefix = 'acal-'
    project.suffix = '-tr'

    assert_equal 'acal-acal-tr', project.idea_element_name
    assert_equal 'acal-acal-tr.ipr', project.local_filename
    assert_equal "#{local_dir}/acal-acal-tr.ipr", project.filename
  end

  def test_resolve_path
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal', :project_directory => local_dir)

    assert_equal '$PROJECT_DIR$/core/foo.txt', project.resolve_path("#{local_dir}/core/foo.txt")
  end

  def test_to_xml
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal', :project_directory => local_dir)

    assert_xml_equal <<XML, project.to_xml
<project version="4">
  <component name="ProjectModuleManager">
    <modules> </modules>
  </component>
</project>
XML
  end
end
