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

class Reality::Idea::TestIdeaFile < Reality::Idea::TestCase
  class TestElement
    include Reality::Idea::Model::IdeaFile

    def initialize(name, directory)
      @name, @directory = name, directory
      idea_file_pre_init
    end

    attr_reader :name

    def extension
      'xml'
    end

    protected

    def _base_directory
      @directory
    end
  end

  def test_idea_element_name
    local_dir = self.random_local_dir
    element1 = TestElement.new('core', local_dir)
    assert_equal 'core', element1.idea_element_name
    assert_equal 'core.xml', element1.local_filename
    assert_equal "#{local_dir}/core.xml", element1.filename

    element2 = TestElement.new('model', local_dir)
    element2.prefix = 'acal-'
    assert_equal 'acal-model', element2.idea_element_name
    assert_equal 'acal-model.xml', element2.local_filename
    assert_equal "#{local_dir}/acal-model.xml", element2.filename

    element3 = TestElement.new('model', local_dir)
    element3.suffix = '-tr'
    assert_equal 'model-tr', element3.idea_element_name
    assert_equal 'model-tr.xml', element3.local_filename
    assert_equal "#{local_dir}/model-tr.xml", element3.filename

    element4 = TestElement.new('model', local_dir)
    element4.prefix = 'acal-'
    element4.suffix = '-tr'
    assert_equal 'acal-model-tr', element4.idea_element_name
    assert_equal 'acal-model-tr.xml', element4.local_filename
    assert_equal "#{local_dir}/acal-model-tr.xml", element4.filename
  end
end
