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

class Reality::Idea::TestModuleManager < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :module_manager,
                     Reality::Idea::Model::ModuleManager)

    assert_equal [], project.module_manager.modules
    project.module_manager.add("#{project.project_directory}/core/core.iml")
    project.module_manager.add("#{project.project_directory}/model/model.iml")
    project.module_manager.add("#{project.project_directory}/shared/shared.iml")
    project.module_manager.add("#{project.project_directory}/server/server.iml", :group => 'Backend')
    assert_equal 4, project.module_manager.modules.size
    assert_equal "#{project.project_directory}/core/core.iml", project.module_manager.modules[0].path
    assert_equal '', project.module_manager.modules[0].group
    assert_equal "#{project.project_directory}/model/model.iml", project.module_manager.modules[1].path
    assert_equal '', project.module_manager.modules[1].group
    assert_equal "#{project.project_directory}/shared/shared.iml", project.module_manager.modules[2].path
    assert_equal '', project.module_manager.modules[2].group
    assert_equal "#{project.project_directory}/server/server.iml", project.module_manager.modules[3].path
    assert_equal 'Backend', project.module_manager.modules[3].group
  end

  def test_build_xml
    project = create_project

    project.module_manager.add("#{project.project_directory}/core/core.iml")
    project.module_manager.add("#{project.project_directory}/model/model.iml")
    project.module_manager.add("#{project.project_directory}/shared/shared.iml")
    project.module_manager.add("#{project.project_directory}/server/server.iml", :group => 'Backend')

    assert_xml_equal <<XML, component_to_xml(project.module_manager)
<component name="ProjectModuleManager">
  <modules>
    <module filepath="$PROJECT_DIR$/core/core.iml" fileurl="file://$PROJECT_DIR$/core/core.iml"/>
    <module filepath="$PROJECT_DIR$/model/model.iml" fileurl="file://$PROJECT_DIR$/model/model.iml"/>
    <module filepath="$PROJECT_DIR$/shared/shared.iml" fileurl="file://$PROJECT_DIR$/shared/shared.iml"/>
    <module filepath="$PROJECT_DIR$/server/server.iml" fileurl="file://$PROJECT_DIR$/server/server.iml" group="Backend"/>
  </modules>
</component>
XML
  end

  def test_build_xml_with_model_modules
    project = create_project

    project.module_manager.add("#{project.project_directory}/core/core.iml")
    project.module_manager.add("#{project.project_directory}/model/model.iml", :group => 'Backend')
    project.ruby_module('api', :module_group => 'MyGroup')
    project.java_module('server')

    assert_xml_equal <<XML, component_to_xml(project.module_manager)
<component name="ProjectModuleManager">
  <modules>
    <module filepath="$PROJECT_DIR$/server/server.iml" fileurl="file://$PROJECT_DIR$/server/server.iml"/>
    <module filepath="$PROJECT_DIR$/api/api.iml" fileurl="file://$PROJECT_DIR$/api/api.iml" group="MyGroup"/>
    <module filepath="$PROJECT_DIR$/core/core.iml" fileurl="file://$PROJECT_DIR$/core/core.iml"/>
    <module filepath="$PROJECT_DIR$/model/model.iml" fileurl="file://$PROJECT_DIR$/model/model.iml" group="Backend"/>
  </modules>
</component>
XML
  end
end
