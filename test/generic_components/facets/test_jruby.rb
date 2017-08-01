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

require File.expand_path('../../../helper', __FILE__)

class Reality::Idea::TestJRubyFacet < Reality::Idea::TestCase
  def test_basic_operation
    project = create_project

    assert_equal [], project.plugin_dependencies.plugins

    mod = project.java_module('foo')
    dir = mod.module_directory
    facet = mod.facets.jruby

    assert_true project.plugin_dependencies.plugins.include?('org.jetbrains.plugins.ruby')

    assert_equal true, facet.is_a?(Reality::Idea::Model::JRubyFacet)
    assert_equal 'JRuby', facet.name
    assert_equal 'JRUBY', facet.type

    assert_equal nil, facet.jruby_version

    facet.jruby_version = 'jruby-1.6.7.2'
    assert_equal 'jruby-1.6.7.2', facet.jruby_version

    facet.load_path << "#{dir}/lib"
    facet.load_path << "#{dir}/test"
    assert_equal 2, facet.load_path.size
    assert_equal %W(#{dir}/lib #{dir}/test), facet.load_path
  end

  def test_build_xml
    mod = create_project.java_module('foo')
    dir = mod.module_directory
    facet = mod.facets.jruby

    facet.jruby_version = 'jruby-1.6.7.2'
    facet.load_path << "#{dir}/lib"
    facet.load_path << "#{dir}/test"

    actual_xml = Reality::Idea::Util.build_xml {|xml| facet.build_xml(xml)}.to_s
    assert_xml_equal <<XML, actual_xml
<facet name="JRuby" type="JRUBY">
  <configuration>
    <JRUBY_FACET_CONFIG_ID NAME="JRUBY_SDK_NAME" VALUE="jruby-1.6.7.2"/>
    <LOAD_PATH number="2" string0="$MODULE_DIR$/lib" string1="$MODULE_DIR$/test"/>
    <I18N_FOLDERS number="0"/>
  </configuration>
</facet>
XML
  end
end
