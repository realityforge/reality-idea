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
      module JavaScriptSettings
        NAME = 'JavaScriptSettings'

        Project.define_component_type(:javascript_settings, JavaScriptSettings)

        attr_reader :language_level

        def language_level=(language_level)
          valid_values = %w(JS_1_5 ES5 JS_1_8_5 ES6 JSX NASHORN FLOW)
          Reality::Idea.error("Component #{self.name} attempted to set invalid language level to '#{language_level}'. Valid values include: #{valid_values}") unless valid_values.include?(language_level)
          @language_level = language_level
        end

        def prefer_strict=(prefer_strict)
          self.component_container.properties.set('JavaScriptPreferStrict', (!!prefer_strict).to_s)
        end

        def prefer_strict?
          prefer_strict = self.component_container.properties.properties['JavaScriptPreferStrict']
          prefer_strict.nil? ? false : 'true' == prefer_strict
        end

        def only_type_based_completion=(only_type_based_completion)
          self.component_container.properties.set('JavaScriptWeakerCompletionTypeGuess', (!only_type_based_completion).to_s)
        end

        def only_type_based_completion?
          only_type_based_completion = self.component_container.properties.properties['JavaScriptWeakerCompletionTypeGuess']
          only_type_based_completion.nil? ? true : 'false' == only_type_based_completion
        end

        protected

        def component_init
          @language_level = 'ES6'
          self.component_container.plugin_dependencies.add('JavaScript')
          self.component_container.plugin_dependencies.add('NodeJS')
        end

        def build_component(xml)
          xml.option(:name => 'languageLevel', :value => self.language_level)
        end
      end
    end
  end
end
