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
      module BaseComponentContainer

        protected

        def component_by_type(module_type)
          name = module_type.const_get(:NAME)
          component = self.component_by_name?(name) ? self.component_by_name(name) : self.component(name)
          unless component.class.include?(module_type)
            component.class.send(:include, module_type)
            component.send(:component_init) if component.respond_to?(:component_init, true)
          end
          component
        end
      end
    end
  end
end
