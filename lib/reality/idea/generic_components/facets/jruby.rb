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

      module JRubyFacet
        NAME = 'JRuby'
        TYPE = 'JRUBY'

        FacetManager.define_facet_type(JavaModuleComponent, TYPE, JRubyFacet)

        attr_accessor :jruby_version

        attr_accessor :load_path

        protected

        def build_configuration(xml)
          load_path_attr = { :number => self.load_path.size }
          self.load_path.each_with_index do |path, i|
            load_path_attr["string#{i}"] = self.facet_manager.component_container.resolve_path(path)
          end
          xml.JRUBY_FACET_CONFIG_ID(:NAME => 'JRUBY_SDK_NAME', :VALUE => self.jruby_version) if self.jruby_version
          xml.LOAD_PATH(load_path_attr)
          xml.I18N_FOLDERS(:number => 0)
        end

        def facet_init
          @jruby_version = nil
          @load_path = []
          self.facet_manager.component_container.project.plugin_dependencies.add('org.jetbrains.plugins.ruby')
        end
      end
    end
  end
end
