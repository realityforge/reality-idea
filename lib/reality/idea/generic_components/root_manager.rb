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
      class SourceFolder < Reality::BaseElement
        def initialize(content_root, path, options = {})
          @content_root = content_root
          @path = path
          @test = false
          @generated = false
          @resource = false
          Reality::Idea.error("Source folder '#{path}' is not contained in content root '#{content_root.path}'") unless File.expand_path(path).start_with?(File.expand_path(content_root.path))
          super(options)
        end

        attr_reader :path

        attr_writer :generated

        def generated?
          !!@generated
        end

        attr_writer :test

        def test?
          !!@test
        end

        attr_writer :resource

        def resource?
          !!@resource
        end

        def build_xml(xml)
          attributes = { :url => @content_root.component.resolve_path_to_url(self.path) }
          if self.resource? && self.test?
            attributes['type'] = 'java-test-resource'
          elsif self.resource? && !self.test?
            attributes['type'] = 'java-resource'
          elsif !self.resource?
            attributes['isTestSource'] = self.test?
          end

          attributes['generated'] = 'true' if self.generated?

          xml.sourceFolder attributes
        end
      end

      class ContentRoot < Reality::BaseElement
        def initialize(component, path, options = {}, &block)
          @component = component
          @path = path
          @exclude_paths = []
          @source_folders = []
          @exclude_pattern = nil
          super(options, &block)
        end

        attr_reader :component
        attr_reader :path

        attr_accessor :exclude_pattern
        attr_accessor :exclude_paths

        def exclude_path(path)
          @exclude_paths << path
        end

        def source_folders
          @source_folders
        end

        def source_folder(path, options = {})
          @source_folders << SourceFolder.new(self, path, options)
        end

        def build_xml(xml)
          xml.content(:url => self.component.resolve_path_to_url(self.path)) do
            self.source_folders.each do |source_folder|
              source_folder.build_xml(xml)
            end
            self.exclude_paths.each do |path|
              xml.excludeFolder :url => self.component.resolve_path_to_url(path)
            end
            xml.excludePattern :pattern => self.exclude_pattern unless '' == self.exclude_pattern.to_s
          end
        end
      end

      class InheritedJdkOrderEntry
        def build_xml(xml)
          xml.orderEntry :type => 'inheritedJdk'
        end
      end

      class SourceFolderOrderEntry
        def build_xml(xml)
          xml.orderEntry :type => 'sourceFolder', :forTests => 'false'
        end
      end

      class DevKitOrderEntry
        def initialize(name, type)
          @name = name
          @type = type
        end

        attr_reader :name
        attr_reader :type

        def build_xml(xml)
          xml.orderEntry :type => 'jdk', 'jdkName' => self.name, 'jdkType' => self.type
        end
      end

      class GemOrderEntry
        def initialize(name, version, ruby_version)
          @name = name
          @version = version
          @ruby_version = ruby_version
        end

        attr_reader :name
        attr_reader :version
        attr_reader :ruby_version

        def build_xml(xml)
          xml.orderEntry :type => 'library', :scope => 'PROVIDED', 'name' => "#{self.name} (v#{self.version}, #{ruby_version}) [gem]", 'level' => 'application'
        end
      end

      class JavaLibraryOrderEntry < Reality::BaseElement
        def initialize(root_manager, options = {}, &block)
          @root_manager = root_manager
          @scope = 'COMPILE'
          @exported = false
          @classes = []
          @javadocs = []
          @sources = []
          options = options.dup
          (options.delete(:sources) || []).each do |source|
            add_sources(source)
          end
          (options.delete(:javadocs) || []).each do |javadoc|
            add_javadocs(javadoc)
          end
          (options.delete(:classes) || []).each do |c|
            add_classes(c)
          end
          super(options, &block)
        end

        attr_reader :classes

        def add_classes(path)
          @classes << path
        end

        attr_reader :javadocs

        def add_javadocs(path)
          @javadocs << path
        end

        attr_reader :sources

        def add_sources(path)
          @sources << path
        end

        attr_reader :scope

        def scope=(scope)
          Reality::Idea.error("ModuleOrderEntry '#{module_name}' attempts to set invalid scope '#{scope}'") unless RootManager::DEPENDENCY_SCOPES.include?(scope)
          @scope = scope
        end

        attr_writer :exported

        def exported?
          !!@exported
        end

        def build_xml(xml)
          attributes = { :type => 'module-library' }
          attributes['exported'] = '' if self.exported?
          attributes['scope'] = self.scope unless self.scope == 'COMPILE'
          xml.orderEntry attributes do
            xml.library do
              xml.CLASSES do
                self.classes.each do |path|
                  root_to_xml(xml, path)
                end
              end unless self.classes.empty?
              xml.JAVADOC do
                self.javadocs.each do |path|
                  root_to_xml(xml, path)
                end
              end unless self.javadocs.empty?
              xml.SOURCES do
                self.sources.each do |path|
                  root_to_xml(xml, path)
                end
              end unless self.sources.empty?
            end
          end
        end

        protected

        def root_to_xml(xml, path)
          @root_manager.component_container.resolve_path_to_url(path)
          url =
            File.directory?(path) ?
              @root_manager.component_container.resolve_path_to_url(path) :
              "jar://#{@root_manager.component_container.resolve_path(path)}!/"
          xml.root :url => url
        end
      end

      class ModuleOrderEntry < Reality::BaseElement
        def initialize(module_name, options = {})
          @module_name = module_name
          @exported = false
          @scope = 'COMPILE'
          super(options)
        end

        attr_reader :module_name

        attr_reader :scope

        def scope=(scope)
          Reality::Idea.error("ModuleOrderEntry '#{module_name}' attempts to set invalid scope '#{scope}'") unless RootManager::DEPENDENCY_SCOPES.include?(scope)
          @scope = scope
        end

        attr_writer :exported

        def exported?
          !!@exported
        end

        def build_xml(xml)
          attributes = { :type => 'module', 'module-name' => self.module_name }
          attributes['exported'] = '' if self.exported?
          attributes['scope'] = self.scope unless self.scope == 'COMPILE'
          xml.orderEntry attributes
        end
      end

      module RootManager
        NAME = 'NewModuleRootManager'

        DEPENDENCY_SCOPES = %w(COMPILE RUNTIME PROVIDED TEST)

        JavaModule.define_component_type(:root_manager, RootManager)
        RubyModule.define_component_type(:root_manager, RootManager)

        attr_writer :inherit_compiler_output

        def inherit_compiler_output?
          !!@inherit_compiler_output
        end

        attr_writer :exclude_output

        def exclude_output?
          !!@exclude_output
        end

        def output_directory=(output_directory)
          self.inherit_compiler_output = false
          @output_directory = output_directory
        end

        def output_directory
          inherit_compiler_output? ? nil : (@output_directory || self.component_container.relative_path("#{self.component_container.module_directory}/out/classes"))
        end

        def test_output_directory=(test_output_directory)
          self.inherit_compiler_output = false
          @test_output_directory = test_output_directory
        end

        def test_output_directory
          inherit_compiler_output? ? nil : (@test_output_directory || self.component_container.relative_path("#{self.component_container.module_directory}/out/test-classes"))
        end

        attr_reader :order_entries

        def inherited_jdk_order_entry
          @order_entries << InheritedJdkOrderEntry.new
        end

        def ruby_sdk_order_entry(ruby_sdk_name)
          @order_entries << DevKitOrderEntry.new(ruby_sdk_name, 'RUBY_SDK')
        end

        def java_sdk_order_entry(java_sdk_name)
          @order_entries << DevKitOrderEntry.new(java_sdk_name, 'JavaSDK')
        end

        def source_folder_order_entry
          @order_entries << SourceFolderOrderEntry.new
        end

        def module_order_entry(module_name, options = {})
          @order_entries << ModuleOrderEntry.new(module_name, options)
        end

        def java_library_order_entry(options = {}, &block)
          Reality::Idea.error("Attempted to add java_library_order_entry to non-java module '#{self.component_container.name}'") unless self.component_container.is_a?(JavaModule)
          @order_entries << JavaLibraryOrderEntry.new(self, options, &block)
        end

        def gem_order_entry(name, version)
          Reality::Idea.error("Attempted to add gem_order_entry to non-ruby module '#{self.component_container.name}'") unless self.component_container.respond_to?(:ruby_development_kit)
          @order_entries << GemOrderEntry.new(name, version, "rbenv: #{self.component_container.ruby_development_kit}")
        end

        attr_reader :content_roots

        def content_root(path, options = {}, &block)
          @content_roots << ContentRoot.new(self, path, options, &block)
        end

        def default_content_root(options = {}, &block)
          content_root(self.component_container.module_directory, options, &block)
        end

        protected

        def component_init
          @order_entries = []
          @content_roots = []
          @inherit_compiler_output = true
          @exclude_output = true
          @output_directory = nil
          @test_output_directory = nil
        end

        def build_component_attributes
          { 'inherit-compiler-output' => self.inherit_compiler_output? }
        end

        def build_component(xml)
          xml.output :url => self.component_container.resolve_path_to_url(self.output_directory) if self.output_directory
          xml.tag!('output-test', :url => self.component_container.resolve_path_to_url(self.test_output_directory)) if self.test_output_directory
          xml.tag!('exclude-output') if self.exclude_output?
          self.content_roots.each do |content_root|
            content_root.build_xml(xml)
          end
          self.order_entries.each do |order_entry|
            order_entry.build_xml(xml)
          end
        end
      end
    end
  end
end
