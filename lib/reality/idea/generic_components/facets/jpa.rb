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

      module JpaFacet
        NAME = 'JPA'
        TYPE = 'jpa'

        FacetManager.define_facet_type(JavaModuleComponent, TYPE, JpaFacet)

        attr_reader :provider_name

        def provider_name=(provider_name)
          valid_provider_names = %w(Hibernate EclipseLink)
          Reality::Idea.error("Attempted to set provider to invalid value '#{provider_name}'. Valid values: #{valid_provider_names.inspect}") unless valid_provider_names.include?(provider_name)
          @provider_name = provider_name
        end

        attr_writer :validation_enabled

        def validation_enabled?
          !!@validation_enabled
        end

        def deployment_descriptor(path)
          @deployment_descriptors << path
        end

        def deployment_descriptors
          @deployment_descriptors.dup
        end

        protected

        def build_configuration(xml)
          xml.setting :name => 'validation-enabled', :value => self.validation_enabled?.to_s
          xml.setting :name => 'provider-name', :value => self.provider_name.to_s
          xml.tag!('datasource-mapping')
          @deployment_descriptors.each do |deployment_descriptor|
            xml.deploymentDescriptor :name => File.basename(deployment_descriptor),
                                     :url => self.facet_manager.component_container.resolve_path_to_url(deployment_descriptor)
          end
        end

        def facet_init
          @validation_enabled = false
          @provider_name = nil
          @deployment_descriptors = []
          self.facet_manager.component_container.project.plugin_dependencies.add('com.intellij.javaee')
        end
      end
    end
  end
end
