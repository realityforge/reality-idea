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

class Reality::Idea::TestJpaFacet < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins

    mod = project.java_module('foo')
    facet = mod.facets.jpa

    assert_true project.plugin_dependencies.plugins.include?('com.intellij.javaee')

    assert_equal true, facet.is_a?(Reality::Idea::Model::JpaFacet)
    assert_equal 'JPA', facet.name
    assert_equal 'jpa', facet.type

    assert_equal false, facet.validation_enabled?
    assert_equal nil, facet.provider_name
    assert_equal 0, facet.deployment_descriptors.size

    facet.provider_name = 'EclipseLink'
    assert_equal 'EclipseLink', facet.provider_name

    facet.validation_enabled = true
    assert_equal true, facet.validation_enabled?

    facet.deployment_descriptor("#{mod.module_directory}/persistence.xml")
    facet.deployment_descriptor("#{mod.module_directory}/orm.xml")
    assert_equal 2, facet.deployment_descriptors.size
    assert_equal %W(#{mod.module_directory}/persistence.xml #{mod.module_directory}/orm.xml), facet.deployment_descriptors
  end

  def test_build_xml
    mod = create_project.java_module('foo')
    facet = mod.facets.jpa

    facet.validation_enabled = true
    facet.provider_name = 'EclipseLink'
    facet.deployment_descriptor("#{mod.module_directory}/persistence.xml")
    facet.deployment_descriptor("#{mod.module_directory}/orm.xml")

    actual_xml = Reality::Idea::Util.build_xml {|xml| facet.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<facet name="JPA" type="jpa">
  <configuration>
    <setting name="validation-enabled" value="true"/>
    <setting name="provider-name" value="EclipseLink"/>
    <datasource-mapping/>
    <deploymentDescriptor name="persistence.xml" url="file://$MODULE_DIR$/persistence.xml"/>
    <deploymentDescriptor name="orm.xml" url="file://$MODULE_DIR$/orm.xml"/>
  </configuration>
</facet>
XML
  end
end
