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
      class Project
        include IdeaFile
        include BaseComponentContainer

        attr_writer :project_directory

        def project_directory
          @project_directory || Reality::Idea.error("Project #{self.name} has not specified a project_directory")
        end

        def extension
          'ipr'
        end

        def default_path_variables
          {}
        end

        def resolve_path(path)
          resolve_path_from_base(path, 'PROJECT_DIR')
        end

        def framework_detection_excludes
          component_by_type(FrameworkDetectionExcludes)
        end

        protected

        def pre_init
          idea_file_pre_init
          @project_directory = nil
        end

        def _base_directory
          self.project_directory
        end
      end
    end
  end
end