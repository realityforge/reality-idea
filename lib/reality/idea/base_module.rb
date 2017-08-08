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
      module BaseModule
        include IdeaFile

        attr_accessor :module_group

        attr_writer :module_directory

        def module_directory
          @module_directory || "#{self.project.project_directory}/#{self.name}"
        end

        def extension
          'iml'
        end

        def resolve_path(path)
          resolve_path_from_base(path, 'MODULE_DIR')
        end

        def to_xml
          pre_build_xml if respond_to?(:pre_build_xml, true)
          Reality::Idea::Util.build_xml do |xml|
            xml.tag!(:module, additional_module_attributes.merge(:type => module_type)) do
              self.components.sort_by {|component| component.name}.each do |component|
                component.build_xml(xml)
              end
            end
          end.to_s
        end

        protected

        def module_type
          Reality::Idea.error("Module #{self.name} has not overridden 'module_type' method")
        end

        def additional_module_attributes
          {}
        end

        def _base_directory
          self.module_directory
        end

        def default_path_variables
          self.project.default_path_variables
        end

        private

        def base_module_pre_init
          @module_directory = nil
          @module_group = nil
          idea_file_pre_init
        end
      end
    end
  end
end
