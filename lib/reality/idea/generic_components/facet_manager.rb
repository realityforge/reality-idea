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
      module FacetManager
        class << self
          def define_facet_type(container_type, key, facet_type)
            facet_types = facet_types_by_container_type(container_type)
            Reality::Idea.error("Duplicate facet registered for container '#{container_type}' with key '#{key}' and facet '#{facet_type}'") if facet_types[key]
            facet_types[key] = facet_type
          end

          def facet_types_by_container_type(container_type)
            facet_type_map = (@facet_type_map ||= {})
            facet_type_map[container_type] ||= {}
          end
        end

        NAME = 'FacetManager'

        JavaModule.define_component_type(:facets, FacetManager)
        RubyModule.define_component_type(:facets, FacetManager)

        def facets
          @facets.values.dup
        end

        protected

        def facet_by_type(facet_type, options = {})
          name = facet_type.const_get(:NAME)
          facet = @facets[name]
          unless facet
            type = facet_type.const_get(:TYPE)
            facet = @facets[name] = Facet.new(self, name, type, facet_type, options)
          end
          facet.options = options
          facet
        end

        def component_init
          @facets = {}
          facet_types = FacetManager.facet_types_by_container_type(self.class)
          facet_types.each_pair do |key, facet_type|
            self.singleton_class.send(:define_method, key) do
              facet_by_type(facet_type)
            end
          end
        end

        def build_component(xml)
          self.facets.each do |task|
            task.build_xml(xml)
          end
        end
      end
    end
  end
end
