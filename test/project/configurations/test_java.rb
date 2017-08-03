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

class Reality::Idea::TestJavaConfiguration < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal 0, project.configurations.configurations.size

    a = project.configurations.java('foo')

    assert_equal 1, project.configurations.configurations.size

    assert_equal true, a.is_a?(Reality::Idea::Model::JavaConfiguration)
    assert_equal 'foo', a.name
    assert_equal 'Application', a.type
    assert_equal 'Application', a.factory_name
    assert_equal false, a.default?

    a.default = true
    assert_equal true, a.default?

    assert_equal '', a.classname
    assert_equal '', a.jvm_args
    assert_equal '', a.args
    assert_equal 2599, a.debug_port
    assert_equal nil, a.module_name
    assert_equal project.project_directory, a.work_dir

    a.classname = 'com.biz.Main'
    assert_equal 'com.biz.Main', a.classname

    a.jvm_args = '-Da=b'
    assert_equal '-Da=b', a.jvm_args

    a.args = '--quiet'
    assert_equal '--quiet', a.args

    a.debug_port = 1965
    assert_equal 1965, a.debug_port

    dir = File.expand_path('.')
    a.work_dir = dir
    assert_equal dir, a.work_dir

    a.module_name = 'core'
    assert_equal 'core', a.module_name
  end

  def test_build_xml
    project = create_project
    a = project.configurations.java('foo')

    a.jvm_args = '-Da=b'
    a.classname = 'com.biz.Main'
    a.args = '--quiet'
    a.debug_port = 1965
    a.module_name = 'core'

    actual_xml = Reality::Idea::Util.build_xml {|xml| a.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<configuration factoryName="Application" name="foo" type="Application">
  <extension enabled="false" merge="false" name="coverage" runner="idea" sample_coverage="true"/>
  <option name="MAIN_CLASS_NAME" value="com.biz.Main"/>
  <option name="VM_PARAMETERS" value="-Da=b"/>
  <option name="PROGRAM_PARAMETERS" value="--quiet"/>
  <option name="WORKING_DIRECTORY" value="file://$PROJECT_DIR$"/>
  <option name="ALTERNATIVE_JRE_PATH_ENABLED" value="false"/>
  <option name="ALTERNATIVE_JRE_PATH" value=""/>
  <option name="ENABLE_SWING_INSPECTOR" value="false"/>
  <option name="ENV_VARIABLES"/>
  <option name="PASS_PARENT_ENVS" value="true"/>
  <module name="core"/>
  <envs/>
  <RunnerSettings RunnerId="Debug">
    <option name="DEBUG_PORT" value="1965"/>
    <option name="TRANSPORT" value="0"/>
    <option name="LOCAL" value="true"/>
  </RunnerSettings>
  <RunnerSettings RunnerId="Run"/>
  <ConfigurationWrapper RunnerId="Debug"/>
  <ConfigurationWrapper RunnerId="Run"/>
  <method/>
</configuration>
XML
  end
end
