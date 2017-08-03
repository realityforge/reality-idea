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

      module TestNGConfiguration
        TYPE = 'TestNG'
        FACTORY_NAME = 'TestNG'

        Configurations.define_configuration_type(:testng, TestNGConfiguration)

        attr_accessor :jvm_args
        attr_accessor :work_dir

        protected

        def build_configuration_xml(xml)
          xml.extension(:name => 'coverage', :enabled => 'false', :merge => 'false', :sample_coverage => 'true', :runner => 'idea')
          xml.option(:name => 'ALTERNATIVE_JRE_PATH_ENABLED', :value => 'false')
          xml.option(:name => 'ALTERNATIVE_JRE_PATH')
          xml.option(:name => 'SUITE_NAME')
          xml.option(:name => 'PACKAGE_NAME')
          xml.option(:name => 'MAIN_CLASS_NAME')
          xml.option(:name => 'METHOD_NAME')
          xml.option(:name => 'GROUP_NAME')
          xml.option(:name => 'TEST_OBJECT', :value => 'CLASS')
          xml.option(:name => 'VM_PARAMETERS', :value => self.jvm_args)
          xml.option(:name => 'PARAMETERS')
          xml.option(:name => 'WORKING_DIRECTORY', :value => self.component.component_container.resolve_path(self.work_dir))
          xml.option(:name => 'OUTPUT_DIRECTORY')
          xml.option(:name => 'ANNOTATION_TYPE')
          xml.option(:name => 'ENV_VARIABLES')
          xml.option(:name => 'PASS_PARENT_ENVS', :value => 'true')
          xml.option(:name => 'TEST_SEARCH_SCOPE') do |opt|
            opt.value(:defaultName => 'moduleWithDependencies')
          end
          xml.option(:name => 'USE_DEFAULT_REPORTERS', :value => 'false')
          xml.option(:name => 'PROPERTIES_FILE')
          xml.envs
          xml.properties
          xml.listeners
          xml.method
        end

        def configuration_init
          @jvm_args = ''
          @work_dir = self.component.component_container.project_directory
          self.component.component_container.plugin_dependencies.add('TestNG-J')
        end
      end
    end
  end
end
