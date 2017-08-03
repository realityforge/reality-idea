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

      module RubyConfiguration
        TYPE = 'RubyRunConfigurationType'
        FACTORY_NAME = 'Ruby'

        Configurations.define_configuration_type(:ruby, RubyConfiguration)

        attr_accessor :ruby_sdk
        attr_accessor :work_dir
        attr_accessor :script_path
        attr_accessor :script_args

        # Name of idea module that hosts ruby module
        attr_accessor :module_name

        protected

        def build_configuration_xml(xml)
          xml.module(:name => self.module_name) if self.module_name

          xml.RUBY_RUN_CONFIG(:NAME => 'RUBY_ARGS', :VALUE => '-e STDOUT.sync=true;STDERR.sync=true;load($0=ARGV.shift)')
          xml.RUBY_RUN_CONFIG(:NAME => 'WORK DIR', :VALUE => self.component.component_container.resolve_path(self.work_dir)) if self.work_dir
          xml.RUBY_RUN_CONFIG(:NAME => 'SHOULD_USE_SDK', :VALUE => 'true')
          xml.RUBY_RUN_CONFIG(:NAME => 'ALTERN_SDK_NAME', :VALUE => self.ruby_sdk) if self.ruby_sdk
          xml.RUBY_RUN_CONFIG(:NAME => 'myPassParentEnvs', :VALUE => 'true')

          xml.envs
          xml.EXTENSION(:ID => 'BundlerRunConfigurationExtension', :bundleExecEnabled => 'false')
          xml.EXTENSION(:ID => 'JRubyRunConfigurationExtension')

          xml.RUBY_RUN_CONFIG(:NAME => 'SCRIPT_PATH', :VALUE => self.script_path) if self.script_path
          xml.RUBY_RUN_CONFIG(:NAME => 'SCRIPT_ARGS', :VALUE => self.script_args) if self.script_args
          xml.RunnerSettings(:RunnerId => 'RubyDebugRunner')
          xml.ConfigurationWrapper(:RunnerId => 'RubyDebugRunner')
        end

        def configuration_init
          @ruby_sdk = nil
          @script_path = nil
          @script_args = nil
          @module_name = nil
          @work_dir = self.component.component_container.project_directory
          self.component.component_container.plugin_dependencies.add('org.jetbrains.plugins.ruby')
        end
      end
    end
  end
end
