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

class Reality::Idea::TestGwtConfiguration < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins
    assert_equal 0, project.configurations.configurations.size

    a = project.configurations.gwt('foo')

    assert_true project.plugin_dependencies.plugins.include?('com.intellij.gwt')
    assert_equal 1, project.configurations.configurations.size

    assert_equal true, a.is_a?(Reality::Idea::Model::GwtConfiguration)
    assert_equal 'foo', a.name
    assert_equal 'GWT.ConfigurationType', a.type
    assert_equal 'GWT Configuration', a.factory_name
    assert_equal false, a.default?

    a.default = true
    assert_equal true, a.default?


    assert_equal true, a.singleton?
    assert_equal false, a.start_javascript_debugger?
    assert_equal '-Xmx512m', a.vm_parameters
    assert_equal nil, a.shell_parameters
    assert_equal nil, a.gwt_module
    assert_equal nil, a.launch_page

    a.singleton = false
    assert_equal false, a.singleton?

    a.start_javascript_debugger = true
    assert_equal true, a.start_javascript_debugger?

    a.vm_parameters = '-Xmx1024m'
    assert_equal '-Xmx1024m', a.vm_parameters

    a.shell_parameters = '-Da=2'
    assert_equal '-Da=2', a.shell_parameters

    a.gwt_module = 'com.biz.MyModule'
    assert_equal 'com.biz.MyModule', a.gwt_module

    a.launch_page = 'http://127.0.0.1:8080/myapp'
    assert_equal 'http://127.0.0.1:8080/myapp', a.launch_page
  end

  def test_build_xml
    project = create_project
    a = project.configurations.gwt('foo')

    a.start_javascript_debugger = true
    a.vm_parameters = '-Xmx1024m'
    a.shell_parameters = '-Da=2'
    a.gwt_module = 'com.biz.MyModule'
    a.launch_page = 'http://127.0.0.1:8080/myapp'

    actual_xml = Reality::Idea::Util.build_xml {|xml| a.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<configuration factoryName="GWT Configuration" name="foo" singleton="true" type="GWT.ConfigurationType">
  <module name=""/>
  <option name="VM_PARAMETERS" value="-Xmx1024m"/>
  <option name="RUN_PAGE" value="http://127.0.0.1:8080/myapp"/>
  <option name="GWT_MODULE" value="com.biz.MyModule"/>
  <option name="START_JAVASCRIPT_DEBUGGER" value="true"/>
  <option name="USE_SUPER_DEV_MODE" value="true"/>
  <option name="SHELL_PARAMETERS" value="-Da=2"/>
  <RunnerSettings RunnerId="Debug">
    <option name="DEBUG_PORT" value=""/>
    <option name="TRANSPORT" value="0"/>
    <option name="LOCAL" value="true"/>
  </RunnerSettings>
  <RunnerSettings RunnerId="Run"/>
  <ConfigurationWrapper RunnerId="Run"/>
  <ConfigurationWrapper RunnerId="Debug"/>
  <method/>
</configuration>
XML
  end
end
