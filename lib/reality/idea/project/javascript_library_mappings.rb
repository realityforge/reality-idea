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
      module JavaScriptLibraryMappings
        NAME = 'JavaScriptLibraryMappings'

        Project.define_component_type(:javascript_library_mappings, JavaScriptLibraryMappings)

        attr_reader :predefined_libraries

        def add_predefined_library(name)
          Reality::Idea.error("Component named '#{self.name}' is attempting to add duplicate predefined library #{name}") if @predefined_libraries.include?(name)
          @predefined_libraries << name
        end

        def add_nodejs_predefined_library
          add_predefined_library('Node.js Core')
        end

        protected

        def component_init
          @predefined_libraries = []
          self.component_container.plugin_dependencies.add('JavaScript')
          self.component_container.plugin_dependencies.add('NodeJS')
        end

        def build_component(xml)
          predefined_libraries.each do |library|
            xml.includedPredefinedLibrary :name => library
          end
        end
      end
    end
  end
end
