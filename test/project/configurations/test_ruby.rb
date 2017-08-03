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

class Reality::Idea::TestRubyConfiguration < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins
    assert_equal 0, project.configurations.configurations.size

    a = project.configurations.ruby('foo')

    assert_true project.plugin_dependencies.plugins.include?('org.jetbrains.plugins.ruby')
    assert_equal 1, project.configurations.configurations.size

    assert_equal true, a.is_a?(Reality::Idea::Model::RubyConfiguration)
    assert_equal 'foo', a.name
    assert_equal 'RubyRunConfigurationType', a.type
    assert_equal 'Ruby', a.factory_name
    assert_equal false, a.default?

    a.default = true
    assert_equal true, a.default?

    assert_equal nil, a.ruby_sdk
    assert_equal nil, a.script_path
    assert_equal nil, a.script_args
    assert_equal project.project_directory, a.work_dir
    assert_equal nil, a.module_name

    a.ruby_sdk = 'rbenv: 2.3.1'
    assert_equal 'rbenv: 2.3.1', a.ruby_sdk

    a.script_path = '/usr/bin/myscript.rb'
    assert_equal '/usr/bin/myscript.rb', a.script_path

    a.script_args = '--quiet'
    assert_equal '--quiet', a.script_args

    dir = File.expand_path('.')
    a.work_dir = dir
    assert_equal dir, a.work_dir

    a.module_name = 'core'
    assert_equal 'core', a.module_name
  end

  def test_build_xml
    project = create_project
    a = project.configurations.ruby('foo')

    a.ruby_sdk = 'rbenv: 2.3.1'
    a.script_path = '/usr/bin/myscript.rb'
    a.script_args = '--quiet'
    a.module_name = 'core'

    actual_xml = Reality::Idea::Util.build_xml {|xml| a.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<configuration factoryName="Ruby" name="foo" type="RubyRunConfigurationType">
  <module name="core"/>
  <RUBY_RUN_CONFIG NAME="RUBY_ARGS" VALUE="-e STDOUT.sync=true;STDERR.sync=true;load($0=ARGV.shift)"/>
  <RUBY_RUN_CONFIG NAME="WORK DIR" VALUE="$PROJECT_DIR$"/>
  <RUBY_RUN_CONFIG NAME="SHOULD_USE_SDK" VALUE="true"/>
  <RUBY_RUN_CONFIG NAME="ALTERN_SDK_NAME" VALUE="rbenv: 2.3.1"/>
  <RUBY_RUN_CONFIG NAME="myPassParentEnvs" VALUE="true"/>
  <envs/>
  <EXTENSION ID="BundlerRunConfigurationExtension" bundleExecEnabled="false"/>
  <EXTENSION ID="JRubyRunConfigurationExtension"/>
  <RUBY_RUN_CONFIG NAME="SCRIPT_PATH" VALUE="/usr/bin/myscript.rb"/>
  <RUBY_RUN_CONFIG NAME="SCRIPT_ARGS" VALUE="--quiet"/>
  <RunnerSettings RunnerId="RubyDebugRunner"/>
  <ConfigurationWrapper RunnerId="RubyDebugRunner"/>
</configuration>
XML
  end
end
