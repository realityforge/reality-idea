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

class Reality::Idea::TestGlassfishConfiguration < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins
    assert_equal 0, project.configurations.configurations.size

    a = project.configurations.glassfish('foo')

    assert_true project.plugin_dependencies.plugins.include?('GlassFish')
    assert_equal 1, project.configurations.configurations.size

    assert_equal true, a.is_a?(Reality::Idea::Model::GlassfishConfiguration)
    assert_equal 'foo', a.name
    assert_equal 'GlassfishConfiguration', a.type
    assert_equal 'Local', a.factory_name
    assert_equal false, a.default?

    a.default = true
    assert_equal true, a.default?

    assert_equal true, a.local?
    assert_equal false, a.remote?
    assert_equal '', a.server_name
    assert_equal '', a.domain_name
    assert_equal 9009, a.debug_port
    assert_equal 0, a.file_deployments.size
    assert_equal 0, a.artifacts.size

    a.local = false
    assert_equal false, a.local?
    assert_equal true, a.remote?
    assert_equal 'Remote', a.factory_name

    a.server_name = 'GlassFish 4.1.0'
    assert_equal 'GlassFish 4.1.0', a.server_name

    a.domain_name = 'acal'
    assert_equal 'acal', a.domain_name

    a.debug_port = 10024
    assert_equal 10024, a.debug_port

    a.artifact('product')
    assert_equal %w(product), a.artifacts

    a.file_deployment('calendar', '/path/to/calendar.war')
    assert_equal({'calendar' => '/path/to/calendar.war'}, a.file_deployments)
  end

  def test_build_xml
    project = create_project
    a = project.configurations.glassfish('foo')

    a.server_name = 'GlassFish 4.1.0'
    a.domain_name = 'acal'
    a.artifact('product')
    a.file_deployment('calendar', "#{project.project_directory}/path/to/calendar.war'")

    actual_xml = Reality::Idea::Util.build_xml {|xml| a.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<configuration APPLICATION_SERVER_NAME="GlassFish 4.1.0" factoryName="Local" name="foo" type="GlassfishConfiguration">
  <option name="OPEN_IN_BROWSER" value="false"/>
  <option name="UPDATING_POLICY" value="restart-server"/>
  <deployment>
    <file path="$PROJECT_DIR$/path/to/calendar.war'">
      <settings>
        <option name="contextRoot" value="/calendar"/>
        <option name="defaultContextRoot" value="false"/>
      </settings>
    </file>
    <artifact name="product">
      <settings/>
    </artifact>
  </deployment>
  <server-settings>
    <option name="DOMAIN" value="acal"/>
    <option name="PRESERVE" value="false"/>
    <option name="COMPATIBILITY" value="false"/>
    <option name="VIRTUAL_SERVER"/>
    <option name="USERNAME" value="admin"/>
    <option name="PASSWORD" value=""/>
  </server-settings>
  <predefined_log_file enabled="true" id="GlassFish"/>
  <extension enabled="false" merge="false" name="coverage" runner="idea" sample_coverage="true"/>
  <RunnerSettings RunnerId="Cover"/>
  <RunnerSettings RunnerId="Cover">
  </RunnerSettings>
  <ConfigurationWrapper RunnerId="Cover" VM_VAR="JAVA_OPTS">
    <option name="USE_ENV_VARIABLES" value="true"/>
    <STARTUP>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </STARTUP>
    <SHUTDOWN>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </SHUTDOWN>
  </ConfigurationWrapper>
  <RunnerSettings RunnerId="Debug">
    <option name="DEBUG_PORT" value="9009"/>
    <option name="TRANSPORT" value="0"/>
    <option name="LOCAL" value="true"/>
  </RunnerSettings>
  <ConfigurationWrapper RunnerId="Debug" VM_VAR="JAVA_OPTS">
    <option name="USE_ENV_VARIABLES" value="true"/>
    <STARTUP>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </STARTUP>
    <SHUTDOWN>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </SHUTDOWN>
  </ConfigurationWrapper>
  <RunnerSettings RunnerId="Run">
  </RunnerSettings>
  <ConfigurationWrapper RunnerId="Run" VM_VAR="JAVA_OPTS">
    <option name="USE_ENV_VARIABLES" value="true"/>
    <STARTUP>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </STARTUP>
    <SHUTDOWN>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </SHUTDOWN>
  </ConfigurationWrapper>
  <method>
    <option enabled="true" name="BuildArtifacts">
      <artifact name="product"/>
    </option>
  </method>
</configuration>
XML
  end


  def test_build_xml_remote_configuration
    project = create_project
    a = project.configurations.glassfish('foo')

    a.local = false
    a.server_name = 'GlassFish 4.1.0'
    a.domain_name = 'acal'
    a.artifact('product')
    a.file_deployment('calendar', "#{project.project_directory}/path/to/calendar.war'")

    actual_xml = Reality::Idea::Util.build_xml {|xml| a.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<configuration APPLICATION_SERVER_NAME="GlassFish 4.1.0" factoryName="Remote" name="foo" type="GlassfishConfiguration">
  <option name="LOCAL" value="false"/>
  <option name="OPEN_IN_BROWSER" value="false"/>
  <option name="UPDATING_POLICY" value="hot-swap-classes"/>
  <deployment>
    <file path="$PROJECT_DIR$/path/to/calendar.war'">
      <settings>
        <option name="contextRoot" value="/calendar"/>
        <option name="defaultContextRoot" value="false"/>
      </settings>
    </file>
    <artifact name="product">
      <settings/>
    </artifact>
  </deployment>
  <server-settings>
    <data>
      <option name="adminServerHost" value=""/>
      <option name="clusterName" value=""/>
      <option name="stagingRemotePath" value=""/>
      <option name="transportHostId"/>
      <option name="transportStagingTarget">
        <TransportTarget>
          <option name="id" value="#{a.transport_id}"/>
          <id>#{a.transport_id}</id>
        </TransportTarget>
      </option>
      <admin-server-host/>
      <cluster-name/>
      <transport-target>
        <option name="id" value="#{a.transport_id}"/>
        <id>#{a.transport_id}</id>
      </transport-target>
      <staging-path/>
      <host-id/>
    </data>
  </server-settings>
  <predefined_log_file enabled="true" id="GlassFish"/>
  <RunnerSettings RunnerId="Debug">
    <option name="DEBUG_PORT" value="9009"/>
    <option name="TRANSPORT" value="0"/>
    <option name="LOCAL" value="false"/>
  </RunnerSettings>
  <ConfigurationWrapper RunnerId="Debug" VM_VAR="JAVA_OPTS">
    <option name="USE_ENV_VARIABLES" value="true"/>
    <STARTUP>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </STARTUP>
    <SHUTDOWN>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </SHUTDOWN>
  </ConfigurationWrapper>
  <RunnerSettings RunnerId="Run">
  </RunnerSettings>
  <ConfigurationWrapper RunnerId="Run" VM_VAR="JAVA_OPTS">
    <option name="USE_ENV_VARIABLES" value="true"/>
    <STARTUP>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </STARTUP>
    <SHUTDOWN>
      <option name="USE_DEFAULT" value="true"/>
      <option name="SCRIPT" value=""/>
      <option name="VM_PARAMETERS" value=""/>
      <option name="PROGRAM_PARAMETERS" value=""/>
    </SHUTDOWN>
  </ConfigurationWrapper>
  <method>
    <option enabled="true" name="BuildArtifacts">
      <artifact name="product"/>
    </option>
  </method>
</configuration>
XML
  end
end
