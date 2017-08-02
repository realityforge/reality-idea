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

class Reality::Idea::TestConfigurations < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :configurations,
                     Reality::Idea::Model::Configurations)

    assert_equal(0, project.configurations.configurations.size)
  end

  def test_build_xml_empty
    project = create_project

    assert_xml_equal <<XML, component_to_xml(project.configurations)
<component name="ProjectRunConfigurationManager">
</component>
XML
  end

  def test_build_xml_single_configuration
    project = create_project

    project.configurations.gwt('Run Acal')

    assert_xml_equal <<XML, component_to_xml(project.configurations)
<component name="ProjectRunConfigurationManager">
  <configuration factoryName="GWT Configuration" name="Run Acal" singleton="true" type="GWT.ConfigurationType">
    <module name=""/>
    <option name="VM_PARAMETERS" value="-Xmx512m"/>
    <option name="START_JAVASCRIPT_DEBUGGER" value="false"/>
    <option name="USE_SUPER_DEV_MODE" value="true"/>
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
</component>
XML
  end

  def test_build_xml_single_default_configuration
    project = create_project

    project.configurations.default_gwt

    assert_xml_equal <<XML, component_to_xml(project.configurations)
<component name="ProjectRunConfigurationManager">
  <configuration default="true" factoryName="GWT Configuration" singleton="true" type="GWT.ConfigurationType">
    <module name=""/>
    <option name="VM_PARAMETERS" value="-Xmx512m"/>
    <option name="START_JAVASCRIPT_DEBUGGER" value="false"/>
    <option name="USE_SUPER_DEV_MODE" value="true"/>
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
</component>
XML
  end

  def test_build_xml_multiple_configurations
    project = create_project

    project.configurations.gwt('Run Acal')
    project.configurations.gwt('Run AcalWidget')

    assert_xml_equal <<XML, component_to_xml(project.configurations)
<component name="ProjectRunConfigurationManager">
  <configuration factoryName="GWT Configuration" name="Run Acal" singleton="true" type="GWT.ConfigurationType">
    <module name=""/>
    <option name="VM_PARAMETERS" value="-Xmx512m"/>
    <option name="START_JAVASCRIPT_DEBUGGER" value="false"/>
    <option name="USE_SUPER_DEV_MODE" value="true"/>
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
  <configuration factoryName="GWT Configuration" name="Run AcalWidget" singleton="true" type="GWT.ConfigurationType">
    <module name=""/>
    <option name="VM_PARAMETERS" value="-Xmx512m"/>
    <option name="START_JAVASCRIPT_DEBUGGER" value="false"/>
    <option name="USE_SUPER_DEV_MODE" value="true"/>
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
</component>
XML
  end
end
