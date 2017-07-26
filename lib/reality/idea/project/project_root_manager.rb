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
      module ProjectRootManager
        NAME = 'ProjectRootManager'

        Project.define_component_type(:project_root_manager, ProjectRootManager)

        attr_reader :jdk_version

        def jdk_version=(jdk_version)
          valid_values = %w(1.3 1.4 1.5 1.6 1.7 1.8 1.9)
          Reality::Idea.error("Component #{self.name} attempted to set invalid jdk_version to '#{jdk_version}'. Valid values include: #{valid_values}") unless valid_values.include?(jdk_version)
          @jdk_version = jdk_version
        end

        attr_writer :output_directory

        def output_directory
          @output_directory || "#{self.project.project_directory}/out"
        end

        protected

        def component_init
          @jdk_version = '1.8'
          @output_directory = nil
        end

        def build_component_attributes
          {
            :version => '2',
            :default => false,
            'project-jdk-name' => self.jdk_version,
            'project-jdk-type' => 'JavaSDK',
           :language_level => "JDK_#{self.jdk_version.gsub('.', '_')}"
          }
        end

        def build_component(xml)
          xml.output('url' => resolve_path_to_url(self.output_directory))
        end
      end
    end
  end
end
