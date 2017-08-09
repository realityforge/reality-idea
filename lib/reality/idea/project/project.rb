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
      class Project
        include IdeaFile
        include BaseComponentContainer

        attr_writer :project_directory

        def project_directory
          @project_directory || Reality::Idea.error("Project #{self.name} has not specified a project_directory")
        end

        def extension
          'ipr'
        end

        def resolve_path(path)
          resolve_path_from_base(path, 'PROJECT_DIR')
        end

        def component_files
          @component_files.dup
        end

        def component_file(component_file)
          @component_files << component_file
        end

        def to_xml
          document = build_base_document
          inject_component_files(document)

          format_document(to_sorted_document(document))
        end

        protected

        def format_document(document)
          output = ''
          formatter = REXML::Formatters::Pretty.new
          formatter.compact = true
          formatter.write(document, output)
          "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n#{output}"
        end

        def build_base_document
          Reality::Idea::Util.build_xml do |xml|
            xml.project(:version => 4) do
              self.components.sort_by {|component| component.name}.each do |component|
                component.build_xml(xml)
              end
            end
          end.document
        end

        def inject_component_files(document)
          self.component_files.each do |component_file|
            Reality::Idea.error("Component file '#{component_file}' specified for project '#{self.name}' does not exist.") unless File.exist?(component_file)
            component_file_doc = Reality::Idea::Util.new_document(IO.read(component_file)).root
            inject_component(document, component_file_doc.root)
          end
        end

        def inject_component(doc, component)
          doc.root.delete_element("//component[@name='#{component.attributes['name']}']")
          doc.root.add_element component
        end

        def pre_init
          idea_file_pre_init
          @project_directory = nil
          @component_files = []
        end

        def post_init
          # Force the creation of module manager component at the very least
          self.module_manager
        end

        def _base_directory
          self.project_directory
        end
      end
    end
  end
end
