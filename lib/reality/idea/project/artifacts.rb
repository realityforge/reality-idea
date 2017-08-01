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

      class Artifact < Reality::BaseElement

        def initialize(component, name, artifact_type, options = {})
          @component = component
          @name = name
          @type = artifact_type.const_get(:TYPE)
          @build_on_make = false
          self.singleton_class.include(artifact_type)
          self.artifact_init if self.respond_to?(:artifact_init, true)
          super(options)
        end

        attr_reader :component
        attr_reader :name
        attr_reader :type

        attr_writer :build_on_make

        def build_on_make?
          !!@build_on_make
        end

        def build_xml(xml)
          xml.artifact(:name => self.name, :type => self.type, 'build-on-make' => self.build_on_make?) do
            build_artifact_xml(xml)
          end
        end

        protected

        def build_artifact_xml(xml)
          Reality::Idea.error("Artifact '#{self.name}' has yet to override method 'build_artifact_xml'")
        end
      end

      module Artifacts
        class << self
          def define_artifact_type(key, artifact_type)
            Reality::Idea.error("Duplicate artifact type registered for key '#{key}'. (Existing artifact_type = '#{artifact_types[key]}', duplicate artifact_type = '#{artifact_type}')") if artifact_types[key]
            artifact_types[key] = artifact_type
          end

          def artifact_types
            @artifact_types ||= {}
          end
        end
        NAME = 'ArtifactManager'

        Project.define_component_type(:artifacts, Artifacts)

        def artifacts
          @artifacts.dup
        end

        protected

        def component_init
          @artifacts = []
          Artifacts.artifact_types.each_pair do |key, artifact_type|
            default_options = {}
            self.singleton_class.send(:define_method, key.to_s.downcase) do |name, options = default_options|
              artifact = Artifact.new(self, name, artifact_type, options)
              @artifacts << artifact
              artifact
            end
          end
        end

        def build_component(xml)
          self.artifacts.each do |artifact|
            artifact.build_xml(xml)
          end
        end
      end
    end
  end
end
