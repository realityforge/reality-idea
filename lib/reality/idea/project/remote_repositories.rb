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

module Reality
  module Idea
    module Model

      class RemoteRepository
        def initialize(component, id, name, url)
          @component = component
          @id = id
          @name = name
          @url = url
        end

        attr_reader :component
        attr_reader :id
        attr_reader :name
        attr_reader :url

        def build_xml(xml)
          xml.tag!('remote-repository') do
            xml.option :name => 'id', :value => self.id
            xml.option :name => 'name', :value => self.name
            xml.option :name => 'url', :value => self.url
          end
        end
      end

      module RemoteRepositories
        NAME = 'RemoteRepositoriesConfiguration'

        Project.define_component_type(:remote_repositories, RemoteRepositories)

        attr_accessor :repositories

        def add(id, name, url)
          @repositories << RemoteRepository.new(self, id, name, url)
        end

        def add_central
          add('central', 'Maven Central repository', 'https://repo1.maven.org/maven2')
        end

        def add_jboss_community
          add('jboss.community', 'JBoss Community repository', 'https://repository.jboss.org/nexus/content/repositories/public/')
        end

        protected

        def component_init
          @repositories = []
          self.component_container.plugin_dependencies.add('org.jetbrains.idea.maven')
        end

        def build_component(xml)
          self.repositories.each do |repository|
            repository.build_xml(xml)
          end
        end
      end
    end
  end
end
