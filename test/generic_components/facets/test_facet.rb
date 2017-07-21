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

require File.expand_path('../../../helper', __FILE__)

class Reality::Idea::TestFacet < Reality::Idea::TestCase
  module TestFacet
    NAME = 'GWT'
    TYPE = 'gwt'

    def init_performed?
      !!@init_performed
    end

    protected

    def build_configuration(xml)
      xml.ignoreme
    end

    def facet_init
      @init_performed = true
    end
  end

  module TestFacet2
    NAME = 'EJB'
    TYPE = 'ejb'
  end

  def test_create
    facet = Reality::Idea::Model::Facet.new(nil, TestFacet)

    assert_equal'GWT', facet.name
    assert_equal'gwt', facet.type
    assert_equal true, facet.init_performed?
  end

  def test_create_with_no_init
    facet = Reality::Idea::Model::Facet.new(nil, TestFacet2)

    assert_equal'EJB', facet.name
    assert_equal'ejb', facet.type
  end

  def test_to_xml
    facet = Reality::Idea::Model::Facet.new(nil, TestFacet)

    actual_xml = Reality::Idea::Util.build_xml {|xml| facet.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<facet name="GWT" type="gwt">
  <configuration>
    <ignoreme/>
  </configuration>
</facet>
XML
  end
end
