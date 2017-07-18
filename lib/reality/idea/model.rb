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
    Reality::Logging.configure(Idea, ::Logger::WARN)

    module Model
      Reality::Model::Repository.new(:Model,
                                     Model,
                                     :log_container => Idea,
                                     :instance_container => Idea) do |r|
        r.model_element(:project)
        r.model_element(:project_component, :project, :access_method => :components, :inverse_access_method => :component)
        r.model_element(:ruby_module, :project)
        r.model_element(:ruby_component, :ruby_module, :access_method => :components, :inverse_access_method => :component)
      end
    end
  end
end
