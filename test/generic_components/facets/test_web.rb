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

class Reality::Idea::TestWebFacet < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins

    mod = project.java_module('foo')
    facet = mod.facets.web

    assert_true project.plugin_dependencies.plugins.include?('com.intellij.javaee')

    assert_equal true, facet.is_a?(Reality::Idea::Model::WebFacet)
    assert_equal 'Web', facet.name
    assert_equal 'web', facet.type

    assert_equal 0, facet.deployment_descriptors.size
    assert_equal 0, facet.web_roots.size

    facet.deployment_descriptor("#{mod.module_directory}/web.xml")
    facet.deployment_descriptor("#{mod.module_directory}/sun-web.xml")
    assert_equal 2, facet.deployment_descriptors.size
    assert_equal %W(#{mod.module_directory}/web.xml #{mod.module_directory}/sun-web.xml), facet.deployment_descriptors

    facet.web_root("#{mod.module_directory}/src/main/webapp")
    facet.web_root("#{mod.module_directory}/generated/fonts", '/fonts')

    assert_equal 2, facet.web_roots.size
    assert_equal({"#{mod.module_directory}/src/main/webapp" => '/', "#{mod.module_directory}/generated/fonts" => '/fonts'}, facet.web_roots)
  end

  def test_build_xml
    mod = create_project.java_module('foo')
    facet = mod.facets.web

    facet.deployment_descriptor("#{mod.module_directory}/web.xml")
    facet.deployment_descriptor("#{mod.module_directory}/sun-web.xml")
    facet.web_root("#{mod.module_directory}/src/main/webapp")
    facet.web_root("#{mod.module_directory}/generated/fonts", '/fonts')

    actual_xml = Reality::Idea::Util.build_xml {|xml| facet.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<facet name="Web" type="web">
  <configuration>
    <descriptors>
      <deploymentDescriptor name="web.xml" url="file://$MODULE_DIR$/web.xml"/>
      <deploymentDescriptor name="sun-web.xml" url="file://$MODULE_DIR$/sun-web.xml"/>
    </descriptors>
    <webroots>
      <root relative="/" url="file://$MODULE_DIR$/src/main/webapp"/>
      <root relative="/fonts" url="file://$MODULE_DIR$/generated/fonts"/>
    </webroots>
  </configuration>
</facet>
XML
  end
end
