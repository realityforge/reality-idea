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

class Reality::Idea::TestTypescriptCompiler < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :typescript_compiler,
                     Reality::Idea::Model::TypeScriptCompiler)

    assert_equal('DETECT', project.typescript_compiler.ts_version_type)
    assert_equal('', project.typescript_compiler.compiler_params)
    assert_equal(nil, project.typescript_compiler.service_directory)
    assert_equal(true, project.typescript_compiler.use_service?)
    assert_equal(true, project.typescript_compiler.use_service_completion?)

    project.typescript_compiler.use_service = false
    project.typescript_compiler.use_service_completion = false
    project.typescript_compiler.compiler_params = '-X'
    project.typescript_compiler.service_directory = File.expand_path('~/.nodenv/versions/6.10.3/bin/node')

    assert_equal('SERVICE_DIRECTORY', project.typescript_compiler.ts_version_type)
    assert_equal('-X', project.typescript_compiler.compiler_params)
    assert_equal(File.expand_path('~/.nodenv/versions/6.10.3/bin/node'), project.typescript_compiler.service_directory)
    assert_equal(false, project.typescript_compiler.use_service?)
    assert_equal(false, project.typescript_compiler.use_service_completion?)
  end

  def test_build_xml
    project = create_project

    assert_xml_equal <<XML, component_to_xml(project.typescript_compiler)
<component name="TypeScriptCompiler">
  <option name="useConfig" value="true"/>
</component>
XML
  end

  def test_build_xml_custom_service_params
    project = create_project

    project.typescript_compiler.use_service_completion = false
    project.typescript_compiler.compiler_params = '-X'
    project.typescript_compiler.ts_version_type = 'EMBEDDED'

    assert_xml_equal <<XML, component_to_xml(project.typescript_compiler)
<component name="TypeScriptCompiler">
  <option name="useConfig" value="true"/>
  <option name="typeScriptCompilerParams" value="-X"/>
  <option name="useServiceCompletion" value="false"/>
  <option name="versionType" value="EMBEDDED"/>
</component>
XML
  end

  def test_build_xml_service_directory_node
    project = create_project

    project.typescript_compiler.service_directory = File.expand_path('~/.nodenv/versions/6.10.3/bin/node')

    assert_xml_equal <<XML, component_to_xml(project.typescript_compiler)
<component name="TypeScriptCompiler">
  <option name="useConfig" value="true"/>
  <option name="versionType" value="SERVICE_DIRECTORY"/>
  <option name="typeScriptServiceDirectory" value="$USER_HOME$/.nodenv/versions/6.10.3/bin/node"/>
</component>
XML
  end
end
