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

class Reality::Idea::TestFixtures < Reality::Idea::TestCase
  FIXTURE_DIR = File.expand_path("#{File.dirname(__FILE__)}/fixtures")

  Dir["#{FIXTURE_DIR}/*"].select {|f| File.directory?(f)}.each do |base_fixture_dir|
    define_method("test_fixture_#{File.basename(base_fixture_dir)}") do
      run_test_for_fixture(base_fixture_dir)
    end
  end

  def run_test_for_fixture(base_fixture_dir)
    input_directory = "#{base_fixture_dir}/input"
    output_directory = local_dir(::SecureRandom.hex)
    FileUtils.mkdir_p File.dirname(output_directory)
    FileUtils.cp_r input_directory, output_directory

    require "#{output_directory}/projects.rb"
    Reality::Idea.projects.each do |p|
      p.save
      p.ruby_modules.each do |m|
        m.save
      end
      p.java_modules.each do |m|
        m.save
      end
    end

    FileUtils.rm_f "#{output_directory}/projects.rb"

    assert_no_diff("#{base_fixture_dir}/output", output_directory)
  end
end
