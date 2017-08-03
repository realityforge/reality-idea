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

      module JavaConfiguration
        TYPE = 'Application'
        FACTORY_NAME = 'Application'

        Configurations.define_configuration_type(:java, JavaConfiguration)

        attr_accessor :debug_port
        attr_accessor :work_dir
        attr_accessor :jvm_args
        attr_accessor :classname
        attr_accessor :args

        # Name of idea module that hosts java module
        attr_accessor :module_name

        protected

        def build_configuration_xml(xml)
          xml.extension(:name => 'coverage', :enabled => 'false', :merge => 'false', :sample_coverage => 'true', :runner => 'idea')
            xml.option(:name => 'MAIN_CLASS_NAME', :value => self.classname)
            xml.option(:name => 'VM_PARAMETERS', :value => self.jvm_args)
            xml.option(:name => 'PROGRAM_PARAMETERS', :value => self.args)
            xml.option(:name => 'WORKING_DIRECTORY', :value => self.component.component_container.resolve_path_to_url(self.work_dir)) if self.work_dir
            xml.option(:name => 'ALTERNATIVE_JRE_PATH_ENABLED', :value => 'false')
            xml.option(:name => 'ALTERNATIVE_JRE_PATH', :value => '')
            xml.option(:name => 'ENABLE_SWING_INSPECTOR', :value => 'false')
            xml.option(:name => 'ENV_VARIABLES')
            xml.option(:name => 'PASS_PARENT_ENVS', :value => 'true')
            xml.module(:name => self.module_name) if self.module_name
            xml.envs
            xml.RunnerSettings(:RunnerId => 'Debug') do
              xml.option(:name => 'DEBUG_PORT', :value => self.debug_port.to_s)
              xml.option(:name => 'TRANSPORT', :value => '0')
              xml.option(:name => 'LOCAL', :value => 'true')
            end
            xml.RunnerSettings(:RunnerId => 'Run')
            xml.ConfigurationWrapper(:RunnerId => 'Debug')
            xml.ConfigurationWrapper(:RunnerId => 'Run')
            xml.method
        end

        def configuration_init
          @classname = ''
          @jvm_args = ''
          @args = ''
          @module_name = nil
          @debug_port = 2599
          @work_dir = self.component.component_container.project_directory
          self.component.component_container.plugin_dependencies.add('org.jetbrains.plugins.java')
        end
      end
    end
  end
end
