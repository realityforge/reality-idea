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

class Reality::Idea::TestTestNGConfiguration < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins
    assert_equal 0, project.configurations.configurations.size

    a = project.configurations.testng('foo')

    assert_true project.plugin_dependencies.plugins.include?('TestNG-J')
    assert_equal 1, project.configurations.configurations.size

    assert_equal true, a.is_a?(Reality::Idea::Model::TestNGConfiguration)
    assert_equal 'foo', a.name
    assert_equal 'TestNG', a.type
    assert_equal 'TestNG', a.factory_name
    assert_equal false, a.default?

    a.default = true
    assert_equal true, a.default?

    assert_equal project.project_directory, a.work_dir
    assert_equal '', a.jvm_args

    a.jvm_args = '-Da=b'
    assert_equal '-Da=b', a.jvm_args

    dir = File.expand_path('.')
    a.work_dir = dir
    assert_equal dir, a.work_dir
  end

  def test_build_xml
    project = create_project
    a = project.configurations.default_testng

    a.jvm_args = '-Da=b'

    actual_xml = Reality::Idea::Util.build_xml {|xml| a.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<configuration default="true" factoryName="TestNG" type="TestNG">
  <extension enabled="false" merge="false" name="coverage" runner="idea" sample_coverage="true"/>
  <option name="ALTERNATIVE_JRE_PATH_ENABLED" value="false"/>
  <option name="ALTERNATIVE_JRE_PATH"/>
  <option name="SUITE_NAME"/>
  <option name="PACKAGE_NAME"/>
  <option name="MAIN_CLASS_NAME"/>
  <option name="METHOD_NAME"/>
  <option name="GROUP_NAME"/>
  <option name="TEST_OBJECT" value="CLASS"/>
  <option name="VM_PARAMETERS" value="-Da=b"/>
  <option name="PARAMETERS"/>
  <option name="WORKING_DIRECTORY" value="$PROJECT_DIR$"/>
  <option name="OUTPUT_DIRECTORY"/>
  <option name="ANNOTATION_TYPE"/>
  <option name="ENV_VARIABLES"/>
  <option name="PASS_PARENT_ENVS" value="true"/>
  <option name="TEST_SEARCH_SCOPE">
    <value defaultName="moduleWithDependencies"/>
  </option>
  <option name="USE_DEFAULT_REPORTERS" value="false"/>
  <option name="PROPERTIES_FILE"/>
  <envs/>
  <properties/>
  <listeners/>
  <method/>
</configuration>
XML
  end
end
