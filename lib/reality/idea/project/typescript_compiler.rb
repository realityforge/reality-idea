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
      module TypeScriptCompiler
        NAME = 'TypeScriptCompiler'

        Project.define_component_type(:typescript_compiler, TypeScriptCompiler)

        # Defaults to empty string if no extra parameters required
        attr_accessor :compiler_params

        # If a specific interpreter needs to be configured then it can be here
        # otherwise the project interpreter will be used
        attr_accessor :node_interpreter

        attr_writer :use_service

        # Defaults to true if service should be used
        def use_service?
          !!@use_service
        end

        attr_writer :use_service_completion

        # Should completion be enabled for service?. Defaults to true
        def use_service_completion?
          !!@use_service_completion
        end

        def ts_version_type
          @ts_version_type
        end

        def ts_version_type=(ts_version_type)
          valid_values = %w(DETECT EMBEDDED SERVICE_DIRECTORY)
          Reality::Idea.error("Component #{self.name} attempted to set invalid ts_version_type to '#{ts_version_type}'. Valid values include: #{valid_values}") unless valid_values.include?(ts_version_type)
          @ts_version_type = ts_version_type
        end

        attr_reader :service_directory

        def service_directory=(service_directory)
          self.ts_version_type = 'SERVICE_DIRECTORY'
          @service_directory = service_directory
        end

        protected

        def component_init
          @use_service = true
          @use_service_completion = true
          @compiler_params = ''
          @node_interpreter = ''
          @ts_version_type = 'DETECT'
        end

        def build_component(xml)
          xml.option :name => 'useConfig', :value => 'true'
          xml.option :name => 'nodeInterpreterTextField', :value => self.resolve_path(self.node_interpreter) if self.node_interpreter.to_s != ''
          xml.option :name => 'typeScriptCompilerParams', :value => self.compiler_params.to_s if self.compiler_params.to_s != ''
          xml.option :name => 'useService', :value => 'false' unless self.use_service?
          xml.option :name => 'useServiceCompletion', :value => 'false' unless self.use_service_completion?
          xml.option :name => 'versionType', :value => self.ts_version_type unless self.ts_version_type == 'DETECT'
          xml.option :name => 'typeScriptServiceDirectory', :value => self.resolve_path(self.service_directory) if self.service_directory && self.ts_version_type == 'SERVICE_DIRECTORY'
        end
      end
    end
  end
end
