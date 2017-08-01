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

      module WebFacet
        NAME = 'Web'
        TYPE = 'web'

        FacetManager.define_facet_type(JavaModuleComponent, TYPE, WebFacet)

        def deployment_descriptor(path)
          @deployment_descriptors << path
        end

        def deployment_descriptors
          @deployment_descriptors.dup
        end

        def web_root(path, relative_path = '/')
          @web_roots[path] = relative_path
        end

        def web_roots
          @web_roots.dup
        end

        protected

        def build_configuration(xml)
          xml.descriptors do
            @deployment_descriptors.each do |deployment_descriptor|
              xml.deploymentDescriptor :name => File.basename(deployment_descriptor),
                                       :url => self.facet_manager.component_container.resolve_path_to_url(deployment_descriptor)
            end
          end
          xml.webroots do
            @web_roots.each_pair do |web_root, relative_path|
              xml.root :url => self.facet_manager.component_container.resolve_path_to_url(web_root), :relative => relative_path
            end
          end
        end

        def facet_init
          @deployment_descriptors = []
          @web_roots = {}
          self.facet_manager.component_container.project.plugin_dependencies.add('com.intellij.javaee')
        end
      end
    end
  end
end
