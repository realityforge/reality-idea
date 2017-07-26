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

class Reality::Idea::TestRemoteRepositories < Reality::Idea::TestCase
  def test_add_central
    project = create_project

    project.remote_repositories.add_central

    assert_equal 1, project.remote_repositories.repositories.size
    assert_equal 'central', project.remote_repositories.repositories[0].id
    assert_equal 'Maven Central repository', project.remote_repositories.repositories[0].name
    assert_equal 'https://repo1.maven.org/maven2', project.remote_repositories.repositories[0].url
  end

  def test_add_jboss_community
    project = create_project

    project.remote_repositories.add_jboss_community

    assert_equal 1, project.remote_repositories.repositories.size
    assert_equal 'jboss.community', project.remote_repositories.repositories[0].id
    assert_equal 'JBoss Community repository', project.remote_repositories.repositories[0].name
    assert_equal 'https://repository.jboss.org/nexus/content/repositories/public/', project.remote_repositories.repositories[0].url
  end

  def test_basic_component_operation
    project = create_project

    assert_equal([], project.plugin_dependencies.plugins)

    assert_component(project,
                     :remote_repositories,
                     Reality::Idea::Model::RemoteRepositories)

    assert_equal(%w(org.jetbrains.idea.maven).sort, project.plugin_dependencies.plugins.sort)

    project.remote_repositories.add('X', 'X Repository', 'https://example.com/x/repo')

    assert_equal 1, project.remote_repositories.repositories.size
    assert_equal 'X', project.remote_repositories.repositories[0].id
    assert_equal 'X Repository', project.remote_repositories.repositories[0].name
    assert_equal 'https://example.com/x/repo', project.remote_repositories.repositories[0].url

    project.remote_repositories.add_central
    project.remote_repositories.add_jboss_community

    assert_equal 3, project.remote_repositories.repositories.size
  end

  def test_build_xml
    project = create_project

    assert_xml_equal <<XML, component_to_xml(project.remote_repositories)
<component name="RemoteRepositoriesConfiguration">
</component>
XML
  end

  def test_build_xml_multiple_remote_repositories
    project = create_project

    project.remote_repositories.add_central
    project.remote_repositories.add_jboss_community
    project.remote_repositories.add('X', 'X Repository', 'https://example.com/x/repo')

    assert_xml_equal <<XML, component_to_xml(project.remote_repositories)
<component name="RemoteRepositoriesConfiguration">
  <remote-repository>
    <option name="id" value="central" />
    <option name="name" value="Maven Central repository" />
    <option name="url" value="https://repo1.maven.org/maven2" />
  </remote-repository>
  <remote-repository>
    <option name="id" value="jboss.community" />
    <option name="name" value="JBoss Community repository" />
    <option name="url" value="https://repository.jboss.org/nexus/content/repositories/public/" />
  </remote-repository>
  <remote-repository>
    <option name="id" value="X" />
    <option name="name" value="X Repository" />
    <option name="url" value="https://example.com/x/repo" />
  </remote-repository>
</component>
XML
  end
end
