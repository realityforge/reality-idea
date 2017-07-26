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
      module VcsDirectoryMappings
        NAME = 'VcsDirectoryMappings'

        Project.define_component_type(:vcs_directory_mappings, VcsDirectoryMappings)

        attr_accessor :mappings

        def add(vcs, path)
          @mappings[vcs] = path
        end

        def add_git(path)
          add('Git', path)
        end

        def add_svn(path)
          add('svn', path)
        end

        # Attempt to detect the vcs for specified directory and add mapping as appropriate
        def detect_vcs(directory)
          if File.exist?("#{directory}/.git")
            add_git(directory)
          elsif File.exist?("#{directory}/.svn")
            add_svn(directory)
          end
        end

        protected

        def component_init
          @mappings = {}
          detect_vcs(self.project.project_directory)
        end

        def build_component(xml)
          self.mappings.each_pair do |vcs, path|
            xml.mapping(:directory => self.resolve_path(path), :vcs => vcs)
          end
        end
      end
    end
  end
end
