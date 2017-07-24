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
      module PluginDependencies
        NAME = 'ExternalDependencies'

        def plugins
          @plugins.dup
        end

        def add(plugin_id)
          @plugins << plugin_id unless @plugins.include?(plugin_id)
          plugin_id
        end

        protected

        def component_init
          @plugins = []
        end

        def build_component(xml)
          self.plugins.sort.each do |plugin_id|
            xml.plugin(:id => plugin_id)
          end
        end
      end
    end
  end
end
