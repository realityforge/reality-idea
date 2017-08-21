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

      class Datasource < Reality::BaseElement
        def initialize(component, name, options = {}, &block)
          @component = component
          @name = name
          @driver = nil
          @url = nil
          @username = nil
          @password = nil
          @schema_pattern = nil
          @default_schemas = nil
          @table_pattern = nil
          @dialect = nil
          @synchronize = true
          @classpath = []
          @uuid = SecureRandom.uuid

          super(options, &block)
        end

        attr_reader :component
        attr_reader :name
        attr_reader :uuid
        attr_accessor :driver
        attr_accessor :url
        attr_accessor :username
        attr_accessor :password
        attr_accessor :schema_pattern
        attr_accessor :default_schemas
        attr_accessor :table_pattern
        attr_accessor :dialect
        attr_accessor :classpath

        attr_writer :synchronize

        def synchronize?
          !!@synchronize
        end

        def build_xml(xml)
          xml.tag!('data-source', :source => 'LOCAL', :name => self.name, :uuid => self.uuid) do
            xml.tag!('synchronize', self.synchronize?)
            xml.tag!('jdbc-driver', self.driver) if self.driver
            xml.tag!('jdbc-url', self.url) if self.url
            xml.tag!('user-name', self.username) if self.username
            xml.tag!('user-password', encrypt(self.password)) if self.password
            xml.tag!('schema-pattern', self.schema_pattern) if self.schema_pattern
            xml.tag!('default-schemas', self.default_schemas) if self.default_schemas
            xml.tag!('table-pattern', self.table_pattern) if self.table_pattern
            xml.tag!('default-dialect', self.dialect) if self.dialect

            xml.libraries do
              self.classpath.each do |classpath_element|
                xml.library do
                  xml.tag!('url', self.component.resolve_path(Reality::Idea::Util.artifact_to_file(classpath_element)))
                end
              end
            end unless self.classpath.empty?
          end
        end

        def encrypt(password)
          password.bytes.inject('') {|x, y| x + (y ^ 0xdfaa).to_s(16)}
        end
      end

      module Datasources
        NAME = 'DataSourceManagerImpl'

        Project.define_component_type(:datasources, Datasources)

        attr_accessor :datasources

        def datasource(name, options = {}, &block)
          datasource = Datasource.new(self, name, options, &block)
          @datasources << datasource
          datasource
        end

        def postgres_datasource(name, options = {})
          params = {
            :driver => 'org.postgresql.Driver',
            :dialect => 'PostgreSQL',
            :classpath => ['org.postgresql:postgresql:jar:9.2-1003-jdbc4']
          }.merge(options)
          datasource(name, params)
        end

        def sql_server_datasource(name, options = {})
          params = {
            :driver => 'net.sourceforge.jtds.jdbc.Driver',
            :dialect => 'TSQL',
            :classpath => ['net.sourceforge.jtds:jtds:jar:1.2.7']
          }.merge(options)

          if params[:url] && /jdbc\:jtds\:sqlserver\:\/\/[^:\\]+(\:\d+)?\/([^;]*)(\;.*)?/ =~ params[:url]
            database_name = $2
            params[:schema_pattern] = "#{database_name}.*" unless params[:schema_pattern]
            params[:default_schemas] = "#{database_name}.*" unless params[:default_schemas]
          end

          datasource(name, params)
        end

        protected

        def component_init
          @datasources = []
        end

        def build_component_attributes
          { :format => 'xml', :hash => '3208837817' }
        end

        def build_component(xml)
          self.datasources.each do |datasource|
            datasource.build_xml(xml)
          end
        end
      end
    end
  end
end
