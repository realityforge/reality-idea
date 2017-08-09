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

  def test_template_files
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal', :project_directory => local_dir)

    assert_equal 0, project.template_files.size

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/mytemplate.xml", <<XML)
<project version="4">
  <component name="X">
  </component>
</project>
XML

    project.template_file("#{local_dir}/mytemplate.xml")

    assert_equal 1, project.template_files.size

    assert_xml_equal <<XML, project.to_xml
<project version="4">
  <component name="ProjectModuleManager">
    <modules> </modules>
  </component>
  <component name="X"> </component>
</project>
XML
  end

  def test_template_files_that_overwrites
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal', :project_directory => local_dir)

    assert_equal 0, project.template_files.size

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/mytemplate1.xml", <<XML)
<project version="4">
  <component name="X">
    <v1/>
  </component>
</project>
XML
    IO.write("#{local_dir}/mytemplate2.xml", <<XML)
<project version="4">
  <component name="Y">
    <v1/>
  </component>
</project>
XML
    IO.write("#{local_dir}/mytemplate3.xml", <<XML)
<project version="4">
  <component name="X">
    <v2/>
  </component>
</project>
XML
    IO.write("#{local_dir}/mytemplate4.xml", <<XML)
<project version="4">
  <component name="ProjectModuleManager">
    <v3/>
  </component>
</project>
XML


    project.template_file("#{local_dir}/mytemplate1.xml")
    project.template_file("#{local_dir}/mytemplate2.xml")
    project.template_file("#{local_dir}/mytemplate3.xml")
    project.template_file("#{local_dir}/mytemplate4.xml")

    assert_equal 4, project.template_files.size

    assert_xml_equal <<XML, project.to_xml
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="ProjectModuleManager">
    <modules> </modules>
  </component>
  <component name="X">
    <v1/>
  </component>
  <component name="Y">
    <v1/>
  </component>
</project>
XML
  end

  def test_component_files
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal', :project_directory => local_dir)

    assert_equal 0, project.component_files.size

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/mycomponent.xml", <<XML)
<component name="X">
</component>
XML

    project.component_file("#{local_dir}/mycomponent.xml")

    assert_equal 1, project.component_files.size

    assert_xml_equal <<XML, project.to_xml
<project version="4">
  <component name="ProjectModuleManager">
    <modules> </modules>
  </component>
  <component name="X"> </component>
</project>
XML
  end

  def test_component_files_that_overwrites
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal', :project_directory => local_dir)

    assert_equal 0, project.component_files.size

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/mycomponent1.xml", <<XML)
<component name="X">
<v1/>
</component>
XML
    IO.write("#{local_dir}/mycomponent2.xml", <<XML)
<component name="Y">
<v1/>
</component>
XML
    IO.write("#{local_dir}/mycomponent3.xml", <<XML)
<component name="X">
<v2/>
</component>
XML

    project.component_file("#{local_dir}/mycomponent1.xml")
    project.component_file("#{local_dir}/mycomponent2.xml")
    project.component_file("#{local_dir}/mycomponent3.xml")

    assert_equal 3, project.component_files.size

    assert_xml_equal <<XML, project.to_xml
<project version="4">
  <component name="ProjectModuleManager">
    <modules> </modules>
  </component>
  <component name="X">
    <v2/>
  </component>
  <component name="Y">
    <v1/>
  </component>
</project>
XML
  end

  def test_to_sorted_document
    local_dir = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal', :project_directory => local_dir)

    assert_equal 0, project.component_files.size

    FileUtils.mkdir_p local_dir
    IO.write("#{local_dir}/mycomponent1.xml", <<XML)
<component name="Z">
</component>
XML
    IO.write("#{local_dir}/mycomponent2.xml", <<XML)
<component name="Y">
</component>
XML
    IO.write("#{local_dir}/mycomponent3.xml", <<XML)
<component name="A">
</component>
XML

    project.component_file("#{local_dir}/mycomponent1.xml")
    project.component_file("#{local_dir}/mycomponent2.xml")
    project.component_file("#{local_dir}/mycomponent3.xml")

    assert_equal 3, project.component_files.size

    assert_xml_equal <<XML, project.to_xml
<project version="4">
  <component name="A"> </component>
  <component name="ProjectModuleManager">
    <modules> </modules>
  </component>
  <component name="Y"> </component>
  <component name="Z"> </component>
</project>
XML
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
