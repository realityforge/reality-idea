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
      module BaseModule
        include IdeaFile
        include BaseComponentContainer

        attr_writer :module_directory

        def module_directory
          @module_directory || "#{self.project.project_directory}/#{self.name}"
        end

        def extension
          'iml'
        end

        def resolve_path(path)
          resolve_path_from_base(path, 'MODULE_DIR')
        end

        protected

        def _base_directory
          self.module_directory
        end

        def default_path_variables
          self.project.default_path_variables
        end

        private

        def base_module_pre_init
          @module_directory = nil
          idea_file_pre_init
        end
      end
    end
  end
end
