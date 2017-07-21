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

      module GwtFacet
        NAME = 'GWT'
        TYPE = 'gwt'

        def settings
          @settings.dup
        end

        def setting(name, value)
          @settings[name] = value
        end

        def gwt_modules
          @gwt_modules.dup
        end

        def gwt_module(name, enabled)
          @gwt_modules[name] = enabled
        end

        protected

        def build_configuration(xml)
          self.settings.each_pair do |k, v|
            xml.setting :name => k.to_s, :value => v.to_s
          end
          xml.packaging do
            self.gwt_modules.each_pair do |k, v|
              xml.module :name => k, :enabled => v
            end
          end
        end

        def facet_init
          @settings = {}
          @gwt_modules = {}
        end
      end
    end
  end
end
