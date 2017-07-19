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
      module FrameworkDetectionExcludes
        NAME = 'FrameworkDetectionExcludesConfiguration'

        attr_accessor :paths

        protected

        def component_init
          Reality::Idea.error("Component #{self.name} expected to have name '#{NAME}'") unless self.name == NAME
          @paths = []
        end

        def build_component(xml)
          self.paths.each do |path|
            xml.file(:url => self.component_container.resolve_path_to_url(path))
          end
        end
      end
    end
  end
end
