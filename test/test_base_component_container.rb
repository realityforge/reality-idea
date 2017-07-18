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

class Reality::Idea::TestBaseComponentContainer < Reality::Idea::TestCase

  module Component1
    NAME = 'Component1'

    def my_attr
      'value1'
    end

    def init_count
      @init_count
    end

    protected

    def component_init
      @init_count ||= 0
      @init_count += 1
    end

    include Reality::Idea::Model::BaseComponent
  end

  module Component2
    NAME = 'Component2'

    def my_attr
      'value2'
    end

    def init_count
      @init_count
    end

    protected

    def component_init
      @init_count ||= 0
      @init_count += 1
    end

    include Reality::Idea::Model::BaseComponent
  end

  def test_component_by_type
    container = create_container

    assert_equal container.components.size, 0

    component = container.send(:component_by_type, Component1)

    assert_equal container.components.size, 1
    assert_not_nil component
    assert_equal component.my_attr, 'value1'
    assert_equal component.init_count, 1

    component_b = container.send(:component_by_type, Component1)

    assert_equal container.components.size, 1
    assert_not_nil component_b
    assert_equal component_b.my_attr, 'value1'
    assert_equal component_b, component
    assert_equal component_b.init_count, 1

    component2 = container.send(:component_by_type, Component2)

    assert_equal container.components.size, 2
    assert_not_nil component2
    assert_equal component2.my_attr, 'value2'
    assert_equal component2.init_count, 1
  end

  private

  def create_container
    Reality::Idea::Model::Project.new('ignored', :project_directory => self.random_local_dir)
  end
end
