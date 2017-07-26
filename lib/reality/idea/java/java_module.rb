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
      class JavaModule
        include BaseModule
        include BaseComponentContainer

        protected

        def module_type
          'JAVA_MODULE'
        end

        def additional_module_attributes
          {:version => '4', :relativePaths => 'true'}
        end

        def pre_init
          base_module_pre_init
          # Need the maven project as we start using MAVEN_REPOSITORY environment
          # variable and remote maven repositories
          self.project.plugin_dependencies.add('org.jetbrains.idea.maven')
        end
      end
    end
  end
end
