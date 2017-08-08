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

require File.expand_path('../helper', __FILE__)

class Reality::Idea::TestBaseModule < Reality::Idea::TestCase
  class TestComponent
    def initialize(name)
      @name = name
    end

    attr_accessor :name

    def build_xml(xml)
      xml.component(:name => @name)
    end
  end

  class TestElement
    include Reality::Idea::Model::BaseModule

    def initialize(project, name)
      @project, @name = project, name
      @components = []
      @additional_module_attributes = {}
      base_module_pre_init
    end

    attr_reader :name

    def project
      @project
    end

    attr_accessor :components
    attr_accessor :additional_module_attributes

    protected

    def module_type
      'TEST_MODULE'
    end
  end

  def test_module_group
    element = TestElement.new(create_project, 'core')

    assert_equal nil, element.module_group

    module_group = random_string
    element.module_group = module_group

    assert_equal module_group, element.module_group
  end

  def test_module_directory
    project = create_project

    element = TestElement.new(project, 'core')

    assert_equal 'core', element.idea_element_name
    assert_equal 'core.iml', element.local_filename
    assert_equal "#{project.project_directory}/core/core.iml", element.filename
    assert_equal "#{project.project_directory}/core", element.module_directory

    local_dir = self.random_local_dir
    element.module_directory = local_dir
    assert_equal local_dir, element.module_directory
    assert_equal "#{local_dir}/core.iml", element.filename
  end

  def test_module_directory_default_module
    project = create_project

    element = TestElement.new(project, project.name)

    assert_equal project.name.to_s, element.idea_element_name
    assert_equal "#{project.name}.iml", element.local_filename
    assert_equal "#{project.project_directory}/#{project.name}.iml", element.filename
    assert_equal project.project_directory, element.module_directory
  end

  def test_resolve_path
    project = create_project
    mod = TestElement.new(project, 'core')

    assert_equal '$MODULE_DIR$/foo.txt', mod.resolve_path("#{project.project_directory}/core/foo.txt")
  end

  def test_to_xml_with_no_components
    mod = TestElement.new(create_project, 'core')

    assert_xml_equal <<XML, mod.to_xml
<module type="TEST_MODULE">
</module>
XML
  end

  def test_to_xml_with_additional_attributes
    mod = TestElement.new(create_project, 'core')

    mod.additional_module_attributes['version'] = 4

    assert_xml_equal <<XML, mod.to_xml
<module type="TEST_MODULE" version="4">
</module>
XML
  end

  def test_to_xml_with_components
    mod = TestElement.new(create_project, 'core')

    mod.components << TestComponent.new('comp2')
    mod.components << TestComponent.new('comp1')

    assert_xml_equal <<XML, mod.to_xml
<module type="TEST_MODULE">
  <component name="comp1"/>
  <component name="comp2"/>
</module>
XML
  end
end
