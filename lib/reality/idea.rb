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

require 'rexml/document'
require 'builder'
require 'pathname'

require 'reality/core'
require 'reality/model'

require 'reality/idea/model'
require 'reality/idea/idea_file'
require 'reality/idea/util'
require 'reality/idea/base_component'
require 'reality/idea/base_component_container'
require 'reality/idea/base_module'
require 'reality/idea/project/project_component'
require 'reality/idea/project/project'
require 'reality/idea/ruby/ruby_module_component'
require 'reality/idea/ruby/ruby_module'
require 'reality/idea/java/java_module_component'
require 'reality/idea/java/java_module'

require 'reality/idea/project/framework_detection_excludes'
require 'reality/idea/project/javascript_library_mappings'
require 'reality/idea/project/javascript_settings'
require 'reality/idea/project/module_manager'
require 'reality/idea/project/plugin_dependencies'
require 'reality/idea/project/project_details'
require 'reality/idea/project/project_root_manager'
require 'reality/idea/project/properties_component'
require 'reality/idea/project/remote_repositories'
require 'reality/idea/project/sql_dialect_mappings'
require 'reality/idea/project/tasks'
require 'reality/idea/project/typescript_compiler'
require 'reality/idea/project/vcs_directory_mappings'

require 'reality/idea/generic_components/facets/facet'
require 'reality/idea/generic_components/facet_manager'
require 'reality/idea/generic_components/facets/gwt'

require 'reality/idea/generic_components/root_manager'

require 'reality/idea/ruby/settings_component'
