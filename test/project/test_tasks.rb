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

class Reality::Idea::TestTasks < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :tasks,
                     Reality::Idea::Model::Tasks)
  end

  def test_build_xml
    project = create_project

    assert_xml_equal <<XML, component_to_xml(project.tasks)
<component name="ProjectTasksOptions">
</component>
XML
  end

  def test_build_xml_single_suppressed_tasks
    project = create_project

    project.tasks.suppressed_tasks << 'Babel'

    assert_xml_equal <<XML, component_to_xml(project.tasks)
<component name="ProjectTasksOptions" suppressed-tasks="Babel">
</component>
XML
  end

  def test_build_xml_multiple_suppressed_tasks
    project = create_project

    project.tasks.suppressed_tasks << 'Babel'
    project.tasks.suppressed_tasks << 'Sass'

    assert_xml_equal <<XML, component_to_xml(project.tasks)
<component name="ProjectTasksOptions" suppressed-tasks="Babel,Sass">
</component>
XML
  end

  def test_build_xml_include_tasks
    project = create_project

    project.tasks.task('Prettier - TSX',
                       :program => '$PROJECT_DIR$/node_modules/.bin/prettier',
                       :arguments => '--print-width 120 --single-quote --write $FilePathRelativeToProjectRoot$',
                       :file_extension => 'tsx',
                       :check_syntax_errors => false )

    assert_xml_equal <<XML, component_to_xml(project.tasks)
<component name="ProjectTasksOptions">
  <TaskOptions isEnabled="true">
    <option name="arguments" value="--print-width 120 --single-quote --write $FilePathRelativeToProjectRoot$"/>
    <option name="checkSyntaxErrors" value="false"/>
    <option name="description" value=""/>
    <option name="exitCodeBehavior" value="ERROR"/>
    <option name="fileExtension" value="tsx"/>
    <option name="immediateSync" value="false"/>
    <option name="name" value="Prettier - TSX"/>
    <option name="output" value=""/>
    <option name="outputFilters">
      <array/>
    </option>
    <option name="outputFromStdout" value="false"/>
    <option name="program" value="$PROJECT_DIR$/../$PROJECT_DIR$/node_modules/.bin/prettier"/>
    <option name="scopeName" value="Project Files"/>
    <option name="trackOnlyRoot" value="false"/>
    <option name="workingDir" value="$ProjectFileDir$"/>
    <envs/>
  </TaskOptions>
</component>
XML
  end


  def test_build_xml_include_multiple_tasks
    project = create_project

    project.tasks.task('Prettier - TS',
                       :program => '$PROJECT_DIR$/node_modules/.bin/prettier',
                       :arguments => '--print-width 120 --single-quote --write $FilePathRelativeToProjectRoot$',
                       :file_extension => 'ts',
                       :check_syntax_errors => false )
    project.tasks.task('Prettier - TSX',
                       :program => '$PROJECT_DIR$/node_modules/.bin/prettier',
                       :arguments => '--print-width 120 --single-quote --write $FilePathRelativeToProjectRoot$',
                       :file_extension => 'tsx',
                       :check_syntax_errors => false )

    assert_xml_equal <<XML, component_to_xml(project.tasks)
<component name="ProjectTasksOptions">
  <TaskOptions isEnabled="true">
    <option name="arguments" value="--print-width 120 --single-quote --write $FilePathRelativeToProjectRoot$"/>
    <option name="checkSyntaxErrors" value="false"/>
    <option name="description" value=""/>
    <option name="exitCodeBehavior" value="ERROR"/>
    <option name="fileExtension" value="ts"/>
    <option name="immediateSync" value="false"/>
    <option name="name" value="Prettier - TS"/>
    <option name="output" value=""/>
    <option name="outputFilters">
      <array/>
    </option>
    <option name="outputFromStdout" value="false"/>
    <option name="program" value="$PROJECT_DIR$/../$PROJECT_DIR$/node_modules/.bin/prettier"/>
    <option name="scopeName" value="Project Files"/>
    <option name="trackOnlyRoot" value="false"/>
    <option name="workingDir" value="$ProjectFileDir$"/>
    <envs/>
  </TaskOptions>
  <TaskOptions isEnabled="true">
    <option name="arguments" value="--print-width 120 --single-quote --write $FilePathRelativeToProjectRoot$"/>
    <option name="checkSyntaxErrors" value="false"/>
    <option name="description" value=""/>
    <option name="exitCodeBehavior" value="ERROR"/>
    <option name="fileExtension" value="tsx"/>
    <option name="immediateSync" value="false"/>
    <option name="name" value="Prettier - TSX"/>
    <option name="output" value=""/>
    <option name="outputFilters">
      <array/>
    </option>
    <option name="outputFromStdout" value="false"/>
    <option name="program" value="$PROJECT_DIR$/../$PROJECT_DIR$/node_modules/.bin/prettier"/>
    <option name="scopeName" value="Project Files"/>
    <option name="trackOnlyRoot" value="false"/>
    <option name="workingDir" value="$ProjectFileDir$"/>
    <envs/>
  </TaskOptions>
</component>
XML
  end
end
