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
      # The BaseComponent should be mixed into all elements that represent IDEA components (Project or Module)
      module BaseComponent
        def to_xml
          create_component(self.name) do |xml|
            build_component(xml)
          end
        end

        def resolve_path(path)
          component_container.resolve_path(path)
        end

        def resolve_path_to_url(path)
          component_container.resolve_path_to_url(path)
        end

        protected

        def component_container
          Reality::Idea.error("Component #{self.name} has not overridden 'component_container' method")
        end

        def build_component(xml)
          Reality::Idea.error("Component #{self.name} has not overridden 'build_component' method")
        end

        def build_component_attributes
          {}
        end

        private

        def create_component(name, &block)
          Reality::Idea::Util.build_xml do |xml|
            xml.component({ :name => name }.merge(self.build_component_attributes)) do
              yield xml if block_given?
            end
          end
        end
      end
    end
  end
end
