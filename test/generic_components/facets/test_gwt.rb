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

class Reality::Idea::TestGwtFacet < Reality::Idea::TestCase
  def test_settings
    facet = Reality::Idea::Model::Facet.new(nil, Reality::Idea::Model::GwtFacet)

    assert_equal({}, facet.settings)
    facet.setting('myKey', 'myValue')
    assert_equal({ 'myKey' => 'myValue' }, facet.settings)
    facet.setting('myKey2', 'myValue2')
    assert_equal({ 'myKey' => 'myValue', 'myKey2' => 'myValue2' }, facet.settings)
    facet.setting('myKey2', 'myValue3')
    assert_equal({ 'myKey' => 'myValue', 'myKey2' => 'myValue3' }, facet.settings)
  end

  def test_gwt_modules
    facet = Reality::Idea::Model::Facet.new(nil, Reality::Idea::Model::GwtFacet)

    assert_equal({}, facet.gwt_modules)
    facet.gwt_module('com.biz.Foo', true)
    assert_equal({ 'com.biz.Foo' => true }, facet.gwt_modules)
    facet.gwt_module('com.biz.Bar', false)
    assert_equal({ 'com.biz.Foo' => true, 'com.biz.Bar' => false }, facet.gwt_modules)
  end

  def test_to_xml
    facet = Reality::Idea::Model::Facet.new(nil, Reality::Idea::Model::GwtFacet)

    facet.setting('myKey', 'myValue')
    facet.setting('myKey2', 'myValue2')
    facet.gwt_module('com.biz.Foo', true)
    facet.gwt_module('com.biz.Bar', false)

    actual_xml = Reality::Idea::Util.build_xml {|xml| facet.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<facet name="GWT" type="gwt">
  <configuration>
    <setting name="myKey" value="myValue"/>
    <setting name="myKey2" value="myValue2"/>
    <packaging>
      <module enabled="true" name="com.biz.Foo"/>
      <module enabled="false" name="com.biz.Bar"/>
    </packaging>
  </configuration>
</facet>
XML
  end
end