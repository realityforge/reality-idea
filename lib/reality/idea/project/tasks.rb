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

      class Task < Reality::BaseElement

        def initialize(component, name, options = {})
          @component = component
          @name = name
          @description = ''
          @program = ''
          @arguments = ''
          @enabled = true
          @check_syntax_errors = true
          @immediate_sync = false
          @output_from_stdout = false
          @track_only_root = false
          @exit_code_behavior = 'ERROR'
          @file_extension = 'ERROR'
          @working_dir = '$ProjectFileDir$'
          @scope_name = 'Project Files'
          super(options)
        end

        attr_reader :component
        attr_reader :name
        attr_accessor :description
        attr_accessor :program
        attr_accessor :arguments
        attr_accessor :file_extension
        attr_accessor :scope_name
        attr_accessor :working_dir

        attr_writer :enabled

        def enabled?
          !!@enabled
        end

          attr_writer :immediate_sync

        def immediate_sync?
          !!@immediate_sync
        end

        attr_writer :check_syntax_errors

        def check_syntax_errors?
          !!@check_syntax_errors
        end

        attr_writer :output_from_stdout

        def output_from_stdout?
          !!@output_from_stdout
        end

        attr_writer :track_only_root

        def track_only_root?
          !!@track_only_root
        end

        attr_reader :exit_code_behavior

        def exit_code_behavior=(exit_code_behavior)
          valid_values = %w(ERROR ALWAYS NEVER)
          Reality::Idea.error("Task named '#{self.name}' specified invalid value '#{exit_code_behavior}' for exit_code_behavior. Valid values include: #{valid_values.inspect}") unless valid_values.include?(exit_code_behavior)
          @exit_code_behavior = exit_code_behavior
        end

        def build_xml(xml)
          xml.TaskOptions(:isEnabled => self.enabled?) do
            xml.option(:name => 'arguments', :value => self.arguments)
            xml.option(:name => 'checkSyntaxErrors', :value => self.check_syntax_errors?)
            xml.option(:name => 'description', :value => self.description)
            xml.option(:name => 'exitCodeBehavior', :value => self.exit_code_behavior)
            xml.option(:name => 'fileExtension', :value => self.file_extension)
            xml.option(:name => 'immediateSync', :value => self.immediate_sync?)
            xml.option(:name => 'name', :value => self.name)
            xml.option(:name => 'output', :value => '')
            xml.option(:name => 'outputFilters') do
              xml.array
            end
            xml.option(:name => 'outputFromStdout', :value => self.output_from_stdout?)
            program = self.program.to_s.strip
            xml.option(:name => 'program', :value => program == '' ? '' : self.component.resolve_path(program))
            xml.option(:name => 'scopeName', :value => self.scope_name)
            xml.option(:name => 'trackOnlyRoot', :value => self.track_only_root?)
            xml.option(:name => 'workingDir', :value => self.working_dir)
            xml.envs
          end
        end
      end

      module Tasks
        NAME = 'ProjectTasksOptions'

        Project.define_component_type(:tasks, Tasks)

        attr_accessor :suppressed_tasks
        attr_accessor :tasks

        def task(name, options = {})
          @tasks << Task.new(self, name, options)
        end

        protected

        def component_init
          @suppressed_tasks = []
          @tasks = []
        end

        def build_component_attributes
          self.suppressed_tasks.empty? ? {} : { 'suppressed-tasks' => self.suppressed_tasks.join(',') }
        end

        def build_component(xml)
          self.tasks.each do |task|
            task.build_xml(xml)
          end
        end
      end
    end
  end
end
