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

class Reality::Idea::TestEjbFacet < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins

    mod = project.java_module('foo')
    facet = mod.facets.ejb

    assert_true project.plugin_dependencies.plugins.include?('com.intellij.javaee')

    assert_equal true, facet.is_a?(Reality::Idea::Model::EjbFacet)
    assert_equal 'EJB', facet.name
    assert_equal 'ejb', facet.type

    assert_equal 0, facet.deployment_descriptors.size
    assert_equal 0, facet.ejb_roots.size

    facet.deployment_descriptor("#{mod.module_directory}/ejb-jar.xml")
    facet.deployment_descriptor("#{mod.module_directory}/sun-ejb-jar.xml")
    assert_equal 2, facet.deployment_descriptors.size
    assert_equal %W(#{mod.module_directory}/ejb-jar.xml #{mod.module_directory}/sun-ejb-jar.xml), facet.deployment_descriptors

    facet.ejb_root("#{mod.module_directory}/src/main/java")
    facet.ejb_root("#{mod.module_directory}/generated/src/main/java")

    assert_equal 2, facet.ejb_roots.size
    assert_equal %W(#{mod.module_directory}/src/main/java #{mod.module_directory}/generated/src/main/java), facet.ejb_roots
  end

  def test_build_xml
    mod = create_project.java_module('foo')
    facet = mod.facets.ejb

    facet.deployment_descriptor("#{mod.module_directory}/ejb-jar.xml")
    facet.deployment_descriptor("#{mod.module_directory}/sun-ejb-jar.xml")

    facet.ejb_root("#{mod.module_directory}/src/main/java")
    facet.ejb_root("#{mod.module_directory}/generated/src/main/java")

    actual_xml = Reality::Idea::Util.build_xml {|xml| facet.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<facet name="EJB" type="ejb">
  <configuration>
    <descriptors>
      <deploymentDescriptor name="ejb-jar.xml" url="file://$MODULE_DIR$/ejb-jar.xml"/>
      <deploymentDescriptor name="sun-ejb-jar.xml" url="file://$MODULE_DIR$/sun-ejb-jar.xml"/>
    </descriptors>
    <ejbRoots>
      <root url="file://$MODULE_DIR$/src/main/java"/>
      <root url="file://$MODULE_DIR$/generated/src/main/java"/>
    </ejbRoots>
  </configuration>
</facet>
XML
  end
end
