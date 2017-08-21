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

        def build_xml(&block)
          target = StringIO.new
          xml = Builder::XmlMarkup.new(:target => target, :indent => 2)
          block.call(xml)
          new_document(target.string).root
        end

        # Converts specified artifact to a filename.
        # The dependency can be a filename or a maven coordinate. If it is a maven coordinate it
        # is expected that it has minimum of 3 components and maximum of 5.
        #
        # i.e.
        # to_file('./myfile.jar') => './myfile.jar'
        # to_file('com.biz:myartifact:2.1') => '/Users/myuser/.m2/repository/com/biz/myartifact/2.1/myartifact-2.1.jar'
        # to_file('com.biz:myartifact:jar:2.1') => '/Users/myuser/.m2/repository/com/biz/myartifact/2.1/myartifact-2.1.jar'
        # to_file('com.biz:myartifact:jar:sources:2.1') => '/Users/myuser/.m2/repository/com/biz/myartifact/2.1/myartifact-2.1-sources.jar'
        def artifact_to_file(dependency)
          components = dependency.split(':')
          return dependency unless [3, 4, 5].include?(components.length)
          group = components[0]
          artifact = components[1]
          version = components.length == 3 ? components[2] : components.length == 4 ? components[3] : components[4]
          type = components.length == 3 ? 'jar' : components[2]
          classification = components.length == 5 ? components[3] : nil
          File.expand_path("~/.m2/repository/#{group.gsub('.','/')}/#{artifact}/#{version}/#{artifact}-#{version}#{classification ? "-#{classification}" : ''}.#{type}")
        end

        # Calculate the relative path between "path" and "directory" parameters.
        # i.e
        # relative_path( '/home/bob/foo', '/home/bob') => 'foo'
        # relative_path( '/home/bob/../z/foo', '/home/bob') => '../z/foo'
        # relative_path( '/home/bob/../bob/foo', '/home/bob') => 'foo'
        #
        def relative_path(path, directory)
          path = Pathname.new(File.expand_path(path)).relative_path_from(Pathname.new(File.expand_path(directory))).to_s
          path == '.' ? '' : path
        end
      end
    end
  end
end
