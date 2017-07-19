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
      module IdeaFile
        attr_writer :prefix
        attr_writer :suffix

        def prefix
          @prefix || ''
        end

        def suffix
          @suffix ||''
        end

        def filename
          File.expand_path("#{_base_directory}/#{local_filename}")
        end

        def local_filename
          "#{idea_element_name}.#{extension}"
        end

        def idea_element_name
          "#{self.prefix}#{self.name}#{self.suffix}"
        end

        def extension
          Reality::Idea.error("IdeaFile #{self.name} has not overridden 'extension' method")
        end

        # The list of variables that are used in idea configuration when resolving paths
        def path_variables
          @path_variables || default_path_variables
        end

        attr_writer :path_variables

        def resolve_path(path)
          Reality::Idea.error("IdeaFile #{self.name} has not overridden 'resolve_path' method")
        end

        def resolve_path_to_url(path)
          "file://#{resolve_path(path)}"
        end

        protected

        def _base_directory
          Reality::Idea.error("IdeaFile #{self.name} has not overridden '_base_directory' method")
        end

        def relative_path(path)
          Reality::Idea::Util.relative_path(path, self._base_directory)
        end

        def default_path_variables
          Reality::Idea.error("IdeaFile #{self.name} has not overridden 'default_path_variables' method")
        end

        def resolve_path_from_base(path, base_variable)
          path_variables.each_pair do |key, path_prefix|
            return path.sub(path_prefix, "$#{key}$") if path.to_s.index(path_prefix) == 0
          end
          begin
            return "$#{base_variable}$/#{relative_path(path)}"
          rescue ArgumentError
            # ArgumentError happens on windows when self._base_directory and path are on different drives
            return path
          end
        end

        private

        def idea_file_pre_init
          @prefix = nil
          @suffix = nil
          @path_variables = nil
        end
      end
    end
  end
end
