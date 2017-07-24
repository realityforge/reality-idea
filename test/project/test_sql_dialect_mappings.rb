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

class Reality::Idea::TestSqlDialectMappings < Reality::Idea::TestCase
  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :sql_dialect_mappings,
                     Reality::Idea::Model::SqlDialectMappings)

    assert_equal({}, project.sql_dialect_mappings.mappings)

    project.sql_dialect_mappings.add('FOO', project.project_directory)
    assert_equal({ 'FOO' => project.project_directory }, project.sql_dialect_mappings.mappings)

    project.sql_dialect_mappings.add_mssql("#{project.project_directory}/sql")
    assert_equal({ 'FOO' => project.project_directory, 'TSQL' => "#{project.project_directory}/sql" }, project.sql_dialect_mappings.mappings)

    project.sql_dialect_mappings.add_postgres("#{project.project_directory}/pgsql")
    assert_equal({ 'FOO' => project.project_directory, 'TSQL' => "#{project.project_directory}/sql", 'PostgreSQL' => "#{project.project_directory}/pgsql" }, project.sql_dialect_mappings.mappings)
  end

  def test_build_xml
    project = create_project

    project.sql_dialect_mappings.add_mssql("#{project.project_directory}/database/mssql")
    project.sql_dialect_mappings.add_postgres("#{project.project_directory}/database/pgsql")

    assert_xml_equal <<XML, component_to_xml(project.sql_dialect_mappings)
<component name="SqlDialectMappings">
  <file dialect="TSQL" url="file://$PROJECT_DIR$/database/mssql"/>
  <file dialect="PostgreSQL" url="file://$PROJECT_DIR$/database/pgsql"/>
</component>
XML
  end
end
