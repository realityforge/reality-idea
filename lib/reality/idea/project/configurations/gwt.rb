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

      module GwtConfiguration
        TYPE = 'GWT.ConfigurationType'
        FACTORY_NAME = 'GWT Configuration'

        Configurations.define_configuration_type(:gwt, GwtConfiguration)

        attr_writer :singleton

        def singleton?
          !!@singleton
        end

        attr_writer :start_javascript_debugger

        def start_javascript_debugger?
          !!@start_javascript_debugger
        end

        attr_accessor :vm_parameters
        attr_accessor :shell_parameters
        attr_accessor :gwt_module
        attr_accessor :launch_page

        # Name of idea module that hosts gwt module
        attr_accessor :module_name

        protected

        def additional_configuration_attributes
          { :singleton => self.singleton? }
        end

        def build_configuration_xml(xml)
          xml.module(:name => self.module_name)

          xml.option(:name => 'VM_PARAMETERS', :value => self.vm_parameters)
          xml.option(:name => 'RUN_PAGE', :value => self.launch_page) if self.launch_page
          xml.option(:name => 'GWT_MODULE', :value => self.gwt_module) if self.gwt_module

          xml.option(:name => 'START_JAVASCRIPT_DEBUGGER', :value => self.start_javascript_debugger?)
          xml.option(:name => 'USE_SUPER_DEV_MODE', :value => true)
          xml.option(:name => 'SHELL_PARAMETERS', :value => self.shell_parameters) if self.shell_parameters

          xml.RunnerSettings(:RunnerId => 'Debug') do
            xml.option(:name => 'DEBUG_PORT', :value => '')
            xml.option(:name => 'TRANSPORT', :value => 0)
            xml.option(:name => 'LOCAL', :value => true)
          end

          xml.RunnerSettings(:RunnerId => 'Run')
          xml.ConfigurationWrapper(:RunnerId => 'Run')
          xml.ConfigurationWrapper(:RunnerId => 'Debug')
          xml.method
        end

        def configuration_init
          @singleton = true
          @start_javascript_debugger = false
          @vm_parameters = '-Xmx512m'
          @shell_parameters = nil
          @gwt_module = nil
          @launch_page = nil
          @module_name = nil
          self.component.component_container.plugin_dependencies.add('com.intellij.gwt')
        end
      end
    end
  end
end
