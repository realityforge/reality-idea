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

require File.expand_path('../helper', __FILE__)

class Reality::Idea::TestBaseModule < Reality::Idea::TestCase
  class TestElement
    include Reality::Idea::Model::BaseModule

    def initialize(name, project)
      @name, @project = name, project
      base_module_pre_init
    end

    attr_reader :name

    def extension
      'xml'
    end

    def project
      @project
    end
  end

  def test_module_directory
    local_dir = self.random_local_dir
    local_dir2 = self.random_local_dir
    project = Reality::Idea::Model::Project.new('acal')
    project.project_directory = local_dir

    element = TestElement.new('core', project)

    assert_equal 'core', element.idea_element_name
    assert_equal 'core.xml', element.local_filename
    assert_equal "#{local_dir}/core/core.xml", element.filename
    assert_equal "#{local_dir}/core", element.module_directory

    element.module_directory = local_dir2
    assert_equal local_dir2, element.module_directory
    assert_equal "#{local_dir2}/core.xml", element.filename
  end
end
