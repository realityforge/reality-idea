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
      module RModuleSettingsStorageComponent
        NAME = 'RModuleSettingsStorage'

        RubyModule.define_component_type(:settings, RModuleSettingsStorageComponent)

        attr_accessor :load_path

        protected

        def component_init
          @load_path = []
        end

        def build_component(xml)
          load_path_attr = { :number => self.load_path.size }
          self.load_path.each_with_index do |path, i|
            load_path_attr["string#{i}"] = self.resolve_path(path)
          end
          xml.LOAD_PATH(load_path_attr)
          xml.I18N_FOLDERS(:number => 0)
        end
      end
    end
  end
end
