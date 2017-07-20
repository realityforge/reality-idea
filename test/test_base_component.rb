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

class Reality::Idea::TestBaseComponent < Reality::Idea::TestCase
  class TestElement
    include Reality::Idea::Model::BaseComponent

    def initialize(name, component_container)
      @name, @component_container = name, component_container
      @component_attributes = {}
    end

    attr_reader :name

    def build_component(xml)
      xml.myChild(:myAttr => 3) do
        xml.myChild
      end
    end

    attr_writer :component_attributes

    def build_component_attributes
      @component_attributes
    end

    def component_container
      @component_container
    end
  end

  def test_create_component
    element = TestElement.new('core', create_project)
    result = element.send(:create_component, 'core')
    assert_xml_equal <<XML.strip, result.to_s
<component name="core">
</component>
XML
  end

  def test_create_component_with_block
    element = TestElement.new('core', create_project)
    result = element.send(:create_component, 'core') do |xml|
      xml.myChild(:myAttr => 3) do
        xml.myChild
      end
    end
    assert_xml_equal <<XML.strip, result.to_s
<component name="core">
  <myChild myAttr="3">
    <myChild/>
  </myChild>
</component>
XML
  end

  def test_to_xml
    element = TestElement.new('core', create_project)
    assert_xml_equal <<XML.strip, element.to_xml.to_s
<component name="core">
  <myChild myAttr="3">
    <myChild/>
  </myChild>
</component>
XML
  end

  def test_to_xml_with_attributes
    element = TestElement.new('core', create_project)
    element.component_attributes = { 'a' => 1 }

    assert_xml_equal <<XML.strip, element.to_xml.to_s
<component name="core" a="1">
  <myChild myAttr="3">
    <myChild/>
  </myChild>
</component>
XML
  end

  def test_resolve_methods
    project = create_project
    element = TestElement.new('core', project)

    assert_equal '$PROJECT_DIR$/src', element.resolve_path("#{project.project_directory}/src")
    assert_equal 'file://$PROJECT_DIR$/src', element.resolve_path_to_url("#{project.project_directory}/src")
  end
end
