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
    module Util
      class << self
        def new_document(value)
          REXML::Document.new(value, :attribute_quote => :quote)
        end

        # Calculate the relative path between "path" and "directory" parameters.
        # i.e
        # relative_path( '/home/bob/foo', '/home/bob') => 'foo'
        # relative_path( '/home/bob/../z/foo', '/home/bob') => '../z/foo'
        # relative_path( '/home/bob/../bob/foo', '/home/bob') => 'foo'
        #
        def relative_path(path, directory)
          Pathname.new(File.expand_path(path)).relative_path_from(Pathname.new(File.expand_path(directory))).to_s
        end
      end
    end
  end
end
