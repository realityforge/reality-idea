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

class Reality::Idea::TestFacetManager < Reality::Idea::TestCase
  module ContainerType
  end

  module FakeFacetType
    NAME = 'FAKE'
    TYPE = 'fake'
  end

  def test_define_facet_type
    assert_equal({}, Reality::Idea::Model::FacetManager.facet_types_by_container_type(ContainerType))
    Reality::Idea::Model::FacetManager.define_facet_type(ContainerType, :fake, FakeFacetType)
    assert_equal({:fake => FakeFacetType}, Reality::Idea::Model::FacetManager.facet_types_by_container_type(ContainerType))
  end

  def test_basic_component_operation
    mod = create_project.java_module('acal')

    assert_component(mod,
                     :facets,
                     Reality::Idea::Model::FacetManager)

    assert_equal 0, mod.facets.facets.size

    mod.facets.gwt

    assert_equal 1, mod.facets.facets.size
  end

  def test_build_xml_no_facets
    mod = create_project.java_module('acal')

    assert_xml_equal <<XML, component_to_xml(mod.facets)
<component name="FacetManager">
</component>
XML
  end

  def test_build_xml_single_facet
    mod = create_project.java_module('acal')

    mod.facets.gwt.setting('A', 'B')

    assert_xml_equal <<XML, component_to_xml(mod.facets)
<component name="FacetManager">
  <facet name="GWT" type="gwt">
    <configuration>
      <setting name="A" value="B"/>
    </configuration>
  </facet>
</component>
XML
  end
end
