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

class Reality::Idea::TestDatasources < Reality::Idea::TestCase
  def test_add_datasource
    project = create_project

    project.datasources.datasource('mssql dev',
                                   :driver => 'net.sourceforge.jtds.jdbc.Driver',
                                   :url => 'jdbc:jtds:sqlserver://example.com:1433/MyDatabase',
                                   :username => 'bob',
                                   :password => 'secret',
                                   :dialect => 'TSQL')

    datasources = project.datasources.datasources
    assert_equal 1, datasources.size
    datasource = datasources[0]
    assert_equal 'mssql dev', datasource.name
    assert_equal 'net.sourceforge.jtds.jdbc.Driver', datasource.driver
    assert_equal 'jdbc:jtds:sqlserver://example.com:1433/MyDatabase', datasource.url
    assert_equal 'bob', datasource.username
    assert_equal 'secret', datasource.password
    assert_equal nil, datasource.schema_pattern
    assert_equal nil, datasource.default_schemas
    assert_equal nil, datasource.table_pattern
    assert_equal 'TSQL', datasource.dialect
    assert_equal true, datasource.synchronize?
    assert_equal [], datasource.classpath

    datasource.driver = 'org.postgresql.Driver'
    datasource.dialect = 'PostgreSQL'
    datasource.classpath << 'org.postgresql:postgresql:jar:9.2-1003-jdbc4'
    assert_equal 'org.postgresql.Driver', datasource.driver
    assert_equal 'PostgreSQL', datasource.dialect
    assert_equal ['org.postgresql:postgresql:jar:9.2-1003-jdbc4'], datasource.classpath

    datasource.synchronize = false
    assert_equal false, datasource.synchronize?

    datasource.schema_pattern = 'BASE.*'
    datasource.default_schemas = 'A,B'
    datasource.table_pattern = 'MYAPP.*'

    assert_equal 'BASE.*', datasource.schema_pattern
    assert_equal 'A,B', datasource.default_schemas
    assert_equal 'MYAPP.*', datasource.table_pattern

    datasource.url = 'jdbc:jtds:sqlserver://example.com:1433/MyOtherDatabase'
    datasource.username = 'bill'
    datasource.password = 'pass'

    assert_equal 'jdbc:jtds:sqlserver://example.com:1433/MyOtherDatabase', datasource.url
    assert_equal 'bill', datasource.username
    assert_equal 'pass', datasource.password
  end

  def test_postgres_datasource
    project = create_project

    project.datasources.postgres_datasource('MYDB')

    datasources = project.datasources.datasources
    assert_equal 1, datasources.size
    datasource = datasources[0]

    assert_equal 'MYDB', datasource.name
    assert_equal 'org.postgresql.Driver', datasource.driver
    assert_equal 'PostgreSQL', datasource.dialect
    assert_equal ['org.postgresql:postgresql:jar:9.2-1003-jdbc4'], datasource.classpath
  end

  def test_sql_server_datasource
    project = create_project

    project.datasources.sql_server_datasource('MYDB')

    datasources = project.datasources.datasources
    assert_equal 1, datasources.size
    datasource = datasources[0]

    assert_equal 'MYDB', datasource.name
    assert_equal 'net.sourceforge.jtds.jdbc.Driver', datasource.driver
    assert_equal 'TSQL', datasource.dialect
    assert_equal ['net.sourceforge.jtds:jtds:jar:1.2.7'], datasource.classpath
    assert_equal nil, datasource.schema_pattern
    assert_equal nil, datasource.default_schemas
  end

  def test_sql_server_datasource_with_url
    project = create_project

    project.datasources.sql_server_datasource('MYDB', :url => 'jdbc:jtds:sqlserver://example.com:1433/MyDatabase')

    datasources = project.datasources.datasources
    assert_equal 1, datasources.size
    datasource = datasources[0]

    assert_equal 'MYDB', datasource.name
    assert_equal 'net.sourceforge.jtds.jdbc.Driver', datasource.driver
    assert_equal 'TSQL', datasource.dialect
    assert_equal ['net.sourceforge.jtds:jtds:jar:1.2.7'], datasource.classpath
    assert_equal 'MyDatabase.*', datasource.schema_pattern
    assert_equal 'MyDatabase.*', datasource.default_schemas
  end

  def test_basic_component_operation
    project = create_project

    assert_component(project,
                     :datasources,
                     Reality::Idea::Model::Datasources)

    project.datasources.sql_server_datasource('MYDB')
    project.datasources.postgres_datasource('OtherDB')

    assert_equal 2, project.datasources.datasources.size
  end

  def test_build_xml
    project = create_project

    assert_xml_equal <<XML, component_to_xml(project.datasources)
<component format="xml" hash="3208837817" name="DataSourceManagerImpl">
</component>
XML
  end

  def test_build_xml_multiple_datasources
    project = create_project

    project.datasources.sql_server_datasource('MYDB')
    project.datasources.postgres_datasource('OtherDB')

    assert_xml_equal <<XML, component_to_xml(project.datasources)
<component format="xml" hash="3208837817" name="DataSourceManagerImpl">
  <data-source name="MYDB" source="LOCAL" uuid="9a436e1f-fe30-4068-b16b-e935b29a7193">
    <synchronize>true</synchronize>
    <jdbc-driver>net.sourceforge.jtds.jdbc.Driver</jdbc-driver>
    <default-dialect>TSQL</default-dialect>
    <libraries>
      <library>
        <url>$MAVEN_REPOSITORY$/net/sourceforge/jtds/jtds/1.2.7/jtds-1.2.7.jar</url>
      </library>
    </libraries>
  </data-source>
  <data-source name="OtherDB" source="LOCAL" uuid="a7c3455b-e8b9-4396-bcb2-5ba65075dfd4">
    <synchronize>true</synchronize>
    <jdbc-driver>org.postgresql.Driver</jdbc-driver>
    <default-dialect>PostgreSQL</default-dialect>
    <libraries>
      <library>
        <url>$MAVEN_REPOSITORY$/org/postgresql/postgresql/9.2-1003-jdbc4/postgresql-9.2-1003-jdbc4.jar</url>
      </library>
    </libraries>
  </data-source>
</component>
XML
  end
end
