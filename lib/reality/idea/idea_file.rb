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

        protected

        def _base_directory
          Reality::Idea.error("IdeaFile #{self.name} has not overridden '_base_directory' method")
        end

        private

        def idea_file_pre_init
          @prefix = nil
          @suffix = nil
        end
      end
    end
  end
end
