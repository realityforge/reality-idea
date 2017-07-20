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

class Reality::Idea::TestUtil < Reality::Idea::TestCase

  def test_idea_element_name
    doc = Reality::Idea::Util.new_document('<my-xml></my-xml>')

    assert_equal 'my-xml', doc.root.name
  end

  def test_build_xml
    element = Reality::Idea::Util.build_xml do |xml|
      xml.foo
    end

    assert_xml_equal <<XML, element.to_s
<foo/>
XML
  end

  def test_relative_path
    dir = working_dir
    assert_equal 'ace', Reality::Idea::Util.relative_path("#{dir}/ace", dir)
    assert_equal 'a/path/to/file', Reality::Idea::Util.relative_path("#{dir}/a/path/to/file", dir)
    assert_equal '../../foo', Reality::Idea::Util.relative_path("#{dir}/../../foo", dir)
    assert_equal 'foo', Reality::Idea::Util.relative_path("#{dir}/../#{File.basename(dir)}/foo", dir)
    assert_equal '', Reality::Idea::Util.relative_path(dir, dir)
  end
end
