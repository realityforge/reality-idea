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
      class RubyModule
        include BaseModule
        include BaseComponentContainer

        attr_writer :ruby_development_kit

        def ruby_development_kit
          @ruby_development_kit ||= calculate_ruby_version
          Reality::Idea.error("Unable to determine ruby_development_kit for module #{self.name}") unless @ruby_development_kit
          @ruby_development_kit
        end

        protected

        def module_type
          'RUBY_MODULE'
        end

        def additional_module_attributes
          {:version => '4'}
        end

        def pre_init
          base_module_pre_init
          @ruby_development_kit = nil
          self.project.plugin_dependencies.add('org.jetbrains.plugins.ruby')
        end

        def calculate_ruby_version
          project_directory = self.project.project_directory
          directory = self.module_directory

          if directory.to_s.start_with?(project_directory.to_s)
            while directory.to_s.start_with?(project_directory.to_s)
              ruby_version = try_load_ruby_version(directory)
              return ruby_version if ruby_version
              directory = File.dirname(directory)
            end
            return nil
          else
            return try_load_ruby_version(directory)
          end
        end

        def try_load_ruby_version(directory)
          filename = "#{directory}/.ruby-version"
          File.exist?(filename) ? IO.read(filename).strip : nil
        end
      end
    end
  end
end
