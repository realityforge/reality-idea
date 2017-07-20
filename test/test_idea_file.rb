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
  MAVEN_REPOSITORY_DIR = File.expand_path('~/.m2/repository')
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

    def resolve_path(path)
      resolve_path_from_base(path, 'MODULE_DIR')
    end

    protected

    def _base_directory
      @directory
    end

    def default_path_variables
      { 'MAVEN_REPOSITORY' => MAVEN_REPOSITORY_DIR }
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

  def test_relative_path
    local_dir = self.random_local_dir
    element1 = TestElement.new('core', local_dir)

    assert_equal 'src/main/java/foo.java', element1.send(:relative_path, "#{local_dir}/src/main/java/foo.java")
    assert_equal 'Buildfile', element1.send(:relative_path, "#{local_dir}/Buildfile")
    assert_equal '../Buildfile', element1.send(:relative_path, File.expand_path("#{local_dir}/../Buildfile"))
  end

  def test_path_variables
    element1 = TestElement.new('core', self.random_local_dir)

    assert_equal ({ 'MAVEN_REPOSITORY' => MAVEN_REPOSITORY_DIR }), element1.path_variables
    element1.path_variables = { 'HOME' => '/User/bob' }
    assert_equal ({ 'HOME' => '/User/bob' }), element1.path_variables
  end

  def test_resolve_path_from_base
    dir = self.random_local_dir
    element1 = TestElement.new('core', dir)
    assert_equal '$MODULE_DIR$/src/main/java', element1.send(:resolve_path_from_base, "#{dir}/src/main/java", 'MODULE_DIR')
    assert_equal '$MODULE_DIR$', element1.send(:resolve_path_from_base, dir, 'MODULE_DIR')
    assert_equal '$MAVEN_REPOSITORY$/org/realityforge/lib/3.0/lib-3.0.jar', element1.send(:resolve_path_from_base, "#{MAVEN_REPOSITORY_DIR}/org/realityforge/lib/3.0/lib-3.0.jar", 'MODULE_DIR')
  end

  def test_resolve_path_to_url
    dir = self.random_local_dir
    element1 = TestElement.new('core', dir)
    assert_equal 'file://$MODULE_DIR$/src/main/java', element1.resolve_path_to_url("#{dir}/src/main/java")
  end
end
