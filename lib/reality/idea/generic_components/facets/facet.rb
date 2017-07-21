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
      class Facet < Reality::BaseElement
        def initialize(facet_manager, module_type, options = {})
          @facet_manager = facet_manager
          @name = module_type.const_get(:NAME)
          @type = module_type.const_get(:TYPE)
          self.singleton_class.include(module_type)
          self.facet_init if self.respond_to?(:facet_init, true)
          super(options)
        end

        attr_reader :facet_manager
        attr_reader :name
        attr_reader :type

        def build_xml(xml)
          xml.facet(:type => self.type, :name => self.name) do
            xml.configuration do
              build_configuration(xml)
            end
          end
        end

        protected

        def build_configuration(xml)
          Reality::Idea.error("Facet #{self.name} has not overridden 'build_configuration' method")
        end
      end
    end
  end
end
