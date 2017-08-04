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

      module GlassfishConfiguration
        TYPE = 'GlassfishConfiguration'
        FACTORY_NAME = 'Local'
        REMOTE_FACTORY_NAME = 'Remote'

        Configurations.define_configuration_type(:glassfish, GlassfishConfiguration)

        def local=(local)
          @factory_name = local ? FACTORY_NAME : REMOTE_FACTORY_NAME
        end

        def local?
          @factory_name == FACTORY_NAME
        end

        def remote?
          !local?
        end

        def artifact(artifact_name)
          @artifacts << artifact_name
        end

        def artifacts
          @artifacts.dup
        end

        def file_deployment(name, filename)
          @file_deployments[name.to_s] = filename
        end

        def file_deployments
          @file_deployments.dup
        end

        attr_accessor :server_name

        attr_accessor :domain_name
        attr_accessor :debug_port

        attr_reader :transport_id

        protected

        def additional_configuration_attributes
          { :APPLICATION_SERVER_NAME => self.server_name }
        end

        def build_configuration_xml(xml)
          xml.option(:name => 'LOCAL', :value => 'false') unless self.local?
          xml.option(:name => 'OPEN_IN_BROWSER', :value => 'false')
          if local?
            xml.option(:name => 'UPDATING_POLICY', :value => 'restart-server')
          else
            xml.option(:name => 'UPDATING_POLICY', :value => 'hot-swap-classes')
          end

          xml.deployment do
            self.file_deployments.each_pair do |name, filename|
              xml.file(:path => self.component.component_container.resolve_path(filename)) do
                xml.settings do
                  #TODO: Figure out if can do this xml.option(:name => 'name', :value => name)
                  xml.option(:name => 'contextRoot', :value => "/#{name}")
                  xml.option(:name => 'defaultContextRoot', :value => 'false')
                end
              end
            end

            self.artifacts.each do |artifact_name|
              xml.artifact(:name => artifact_name) do
                xml.settings
              end
            end
          end
          xml.tag! 'server-settings' do
            if self.local?
              xml.option(:name => 'DOMAIN', :value => self.domain_name)
              xml.option(:name => 'PRESERVE', :value => 'false')
              xml.option(:name => 'COMPATIBILITY', :value => 'false')
              xml.option(:name => 'VIRTUAL_SERVER')
              xml.option(:name => 'USERNAME', :value => 'admin')
              xml.option(:name => 'PASSWORD', :value => '')
            else
              xml.data do
                xml.option(:name => 'adminServerHost', :value => '')
                xml.option(:name => 'clusterName', :value => '')
                xml.option(:name => 'stagingRemotePath', :value => '')
                xml.option(:name => 'transportHostId')
                xml.option(:name => 'transportStagingTarget') do
                  xml.TransportTarget do
                    xml.option(:name => 'id', :value => self.transport_id)
                    xml.id(self.transport_id)
                  end
                end
                xml.tag!('admin-server-host')
                xml.tag!('cluster-name')
                xml.tag!('transport-target') do
                  xml.option(:name => 'id', :value => self.transport_id)
                  xml.id(self.transport_id)
                end
                xml.tag!('staging-path')
                xml.tag!('host-id')
              end
            end
          end

          xml.predefined_log_file(:id => 'GlassFish', :enabled => 'true')

          if self.local?
            xml.extension(:name => 'coverage', :enabled => 'false', :merge => 'false', :sample_coverage => 'true', :runner => 'idea')

            xml.RunnerSettings(:RunnerId => 'Cover')

            add_glassfish_runner_settings(xml, 'Cover')
            add_glassfish_configuration_wrapper(xml, 'Cover')
          end

          add_glassfish_runner_settings(xml, 'Debug', {
            :DEBUG_PORT => self.debug_port.to_s,
            :TRANSPORT => '0',
            :LOCAL => self.local?,
          })
          add_glassfish_configuration_wrapper(xml, 'Debug')

          add_glassfish_runner_settings(xml, 'Run')
          add_glassfish_configuration_wrapper(xml, 'Run')

          xml.method do |method|
            method.option(:name => 'BuildArtifacts', :enabled => 'true') do |option|
              self.artifacts.each do |artifact_name|
                option.artifact(:name => artifact_name)
              end
            end
          end
        end

        def add_glassfish_runner_settings(xml, name, options = {})
          xml.RunnerSettings(:RunnerId => name.to_s) do |runner_settings|
            options.each do |key, value|
              runner_settings.option(:name => key.to_s, :value => value.to_s)
            end
          end
        end

        def add_glassfish_configuration_wrapper(xml, name)
          xml.ConfigurationWrapper(:VM_VAR => 'JAVA_OPTS', :RunnerId => name.to_s) do |configuration_wrapper|
            configuration_wrapper.option(:name => 'USE_ENV_VARIABLES', :value => 'true')
            configuration_wrapper.STARTUP do |startup|
              startup.option(:name => 'USE_DEFAULT', :value => 'true')
              startup.option(:name => 'SCRIPT', :value => '')
              startup.option(:name => 'VM_PARAMETERS', :value => '')
              startup.option(:name => 'PROGRAM_PARAMETERS', :value => '')
            end
            configuration_wrapper.SHUTDOWN do |shutdown|
              shutdown.option(:name => 'USE_DEFAULT', :value => 'true')
              shutdown.option(:name => 'SCRIPT', :value => '')
              shutdown.option(:name => 'VM_PARAMETERS', :value => '')
              shutdown.option(:name => 'PROGRAM_PARAMETERS', :value => '')
            end
          end
        end

        def configuration_init
          @artifacts = []
          @file_deployments = {}
          @server_name = ''
          @domain_name = ''
          @debug_port = 9009
          @transport_id = SecureRandom.uuid.to_s
          self.component.component_container.plugin_dependencies.add('GlassFish')
        end
      end
    end
  end
end
