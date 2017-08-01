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

      module JarArtifact
        TYPE = 'jar'

        Artifacts.define_artifact_type(TYPE, JarArtifact)

        attr_writer :output_dir

        def output_dir
          @output_dir || "#{self.component.component_container.project_directory}/artifacts/#{self.name}"
        end

        attr_writer :jar_name

        def jar_name
          @jar_name || "#{self.name}.jar"
        end

        def module_output(module_name)
          @module_outputs << module_name
        end

        def module_outputs
          @module_outputs.dup
        end

        def jpa_module(module_name)
          @jpa_modules << module_name
        end

        def jpa_modules
          @jpa_modules.dup
        end

        def ejb_module(module_name)
          @ejb_modules << module_name
        end

        def ejb_modules
          @ejb_modules.dup
        end

        protected

        def build_artifact_xml(xml)
          xml.tag!('output-path', self.component.component_container.resolve_path(self.output_dir))
          xml.root(:id => 'archive', :name => self.jar_name) do
            self.module_outputs.each do |module_output|
              xml.element :id => 'module-output', :name => module_output
            end
            self.jpa_modules.each do |jpa_module|
              xml.element :id => 'jpa-descriptors', :facet => "#{jpa_module}/jpa/JPA"
            end
            self.ejb_modules.each do |ejb_module|
              xml.element :id => 'javaee-facet-resources', :facet => "#{ejb_module}/ejb/EJB"
            end
          end
        end

        def artifact_init
          @jar_name = nil
          @output_dir = nil
          @module_outputs = []
          @jpa_modules = []
          @ejb_modules = []
          self.component.component_container.plugin_dependencies.add('com.intellij.javaee')
        end
      end
    end
  end
end
