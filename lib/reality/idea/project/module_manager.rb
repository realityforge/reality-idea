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

      class ModuleDef < Reality::BaseElement
        def initialize(component, path, options = {})
          @component = component
          @path = path
          @group = ''
          super(options)
        end

        attr_reader :component
        attr_reader :path
        attr_accessor :group

        def build_xml(xml)
          attributes =
            {
              :fileurl => component.resolve_path_to_url(self.path),
              :filepath => component.resolve_path(self.path)
            }
          attributes[:group] = self.group unless self.group == ''

          xml.module attributes
        end
      end

      module ModuleManager
        NAME = 'ProjectModuleManager'

        Project.define_component_type(:module_manager, ModuleManager)

        attr_accessor :modules

        def add(path, options = {})
          @modules << ModuleDef.new(self, path, options)
        end

        protected

        def component_init
          @modules = []
        end

        def build_component(xml)
          xml.modules do
            self.modules.each do |task|
              task.build_xml(xml)
            end
          end
        end
      end
    end
  end
end
