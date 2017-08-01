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

class Reality::Idea::TestJarArtifact < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins
    assert_equal 0, project.artifacts.artifacts.size

    a = project.artifacts.jar('foo')

    assert_true project.plugin_dependencies.plugins.include?('com.intellij.javaee')
    assert_equal 1, project.artifacts.artifacts.size

    assert_equal true, a.is_a?(Reality::Idea::Model::JarArtifact)
    assert_equal 'foo', a.name
    assert_equal 'jar', a.type
    assert_equal false, a.build_on_make?

    a.build_on_make = true
    assert_equal true, a.build_on_make?

    assert_equal "#{project.project_directory}/artifacts/foo", a.output_dir
    assert_equal 'foo.jar', a.jar_name
    assert_equal 0, a.module_outputs.size
    assert_equal 0, a.jpa_modules.size
    assert_equal 0, a.ejb_modules.size

    a.jar_name = 'foo-1.0.jar'
    assert_equal 'foo-1.0.jar', a.jar_name

    a.output_dir = "#{project.project_directory}/artifacts/foo-1.0"
    assert_equal "#{project.project_directory}/artifacts/foo-1.0", a.output_dir

    a.module_output('core')
    a.module_output('model')
    a.module_output('server')

    assert_equal 3, a.module_outputs.size
    assert_equal %w(core model server), a.module_outputs

    a.jpa_module('model')

    assert_equal 1, a.jpa_modules.size
    assert_equal %w(model), a.jpa_modules

    a.ejb_module('server')

    assert_equal 1, a.ejb_modules.size
    assert_equal %w(server), a.ejb_modules
  end

  def test_build_xml
    project = create_project
    a = project.artifacts.jar('foo')

    a.module_output('shared')
    a.module_output('model')
    a.module_output('server')
    a.jpa_module('model')
    a.ejb_module('server')

    actual_xml = Reality::Idea::Util.build_xml {|xml| a.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<artifact build-on-make="false" name="foo" type="jar">
  <output-path>$PROJECT_DIR$/artifacts/foo</output-path>
  <root id="archive" name="foo.jar">
    <element id="module-output" name="shared"/>
    <element id="module-output" name="model"/>
    <element id="module-output" name="server"/>
    <element facet="model/jpa/JPA" id="jpa-descriptors"/>
    <element facet="server/ejb/EJB" id="javaee-facet-resources"/>
  </root>
</artifact>
XML
  end
end
