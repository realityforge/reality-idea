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

      class Configuration < Reality::BaseElement

        def initialize(component, name, configuration_type, options = {})
          @component = component
          @name = name
          @type = configuration_type.const_get(:TYPE)
          @factory_name = configuration_type.const_get(:FACTORY_NAME)
          @default = false
          self.singleton_class.include(configuration_type)
          self.configuration_init if self.respond_to?(:configuration_init, true)
          super(options)
        end

        attr_reader :component
        attr_reader :name
        attr_reader :type
        attr_reader :factory_name

        attr_writer :default

        def default?
          !!@default
        end

        def build_xml(xml)
          attributes = {:type => self.type, :name => self.name, :factoryName => self.factory_name}
          attributes[:default] = true if default?
          attributes.merge!(self.additional_configuration_attributes) if self.respond_to?(:additional_configuration_attributes, true)
          xml.configuration(attributes) do
            build_configuration_xml(xml)
          end
        end

        protected

        def build_configuration_xml(xml)
          Reality::Idea.error("Configuration '#{self.name}' has yet to override method 'build_configuration_xml'")
        end
      end

      module Configurations
        class << self
          def define_configuration_type(key, configuration_type)
            Reality::Idea.error("Duplicate configuration type registered for key '#{key}'. (Existing configuration_type = '#{configuration_types[key]}', duplicate configuration_type = '#{configuration_type}')") if configuration_types[key]
            configuration_types[key] = configuration_type
          end

          def configuration_types
            @configuration_types ||= {}
          end
        end
        NAME = 'ProjectRunConfigurationManager'

        Project.define_component_type(:configurations, Configurations)

        def configurations
          @configurations.dup
        end

        protected

        def component_init
          @configurations = []
          Configurations.configuration_types.each_pair do |key, configuration_type|
            default_options = {}
            method_name = key.to_s.downcase.gsub('-', '_')
            self.singleton_class.send(:define_method, method_name) do |name, options = default_options|
              configuration = Configuration.new(self, name, configuration_type, options)
              @configurations << configuration
              configuration
            end
          end
        end

        def build_component(xml)
          self.configurations.each do |configuration|
            configuration.build_xml(xml)
          end
        end
      end
    end
  end
end
