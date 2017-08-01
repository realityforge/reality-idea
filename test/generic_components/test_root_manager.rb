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

require File.expand_path('../../helper', __FILE__)

class Reality::Idea::TestRootManager < Reality::Idea::TestCase
  def test_basic_component_operation
    mod = create_project.java_module(random_string)

    assert_component(mod,
                     :root_manager,
                     Reality::Idea::Model::RootManager)

    assert_equal true, mod.root_manager.inherit_compiler_output?
    assert_equal true, mod.root_manager.exclude_output?
    assert_equal nil, mod.root_manager.output_directory
    assert_equal nil, mod.root_manager.test_output_directory
    assert_equal 0, mod.root_manager.order_entries.size
    assert_equal 0, mod.root_manager.content_roots.size

    mod.root_manager.inherit_compiler_output = false

    assert_equal false, mod.root_manager.inherit_compiler_output?
    assert_equal 'out/classes', mod.root_manager.output_directory
    assert_equal 'out/test-classes', mod.root_manager.test_output_directory

    mod.root_manager.exclude_output = false

    assert_equal false, mod.root_manager.exclude_output?

    mod.root_manager.inherited_jdk_order_entry

    assert_equal 1, mod.root_manager.order_entries.size

    mod.root_manager.content_root(mod.module_directory)

    assert_equal 1, mod.root_manager.content_roots.size

    assert_equal false, mod.root_manager.inherit_compiler_output?
    assert_equal false, mod.root_manager.exclude_output?
    assert_equal 'out/classes', mod.root_manager.output_directory
    assert_equal 'out/test-classes', mod.root_manager.test_output_directory
    assert_equal 1, mod.root_manager.order_entries.size
    assert_equal 1, mod.root_manager.content_roots.size
  end

  def test_build_xml_all_defaults
    mod = create_project.java_module(random_string)

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
</component>
XML
  end

  def test_build_xml_inherited_jdk_order_entry
    mod = create_project.java_module(random_string)

    mod.root_manager.inherited_jdk_order_entry

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <orderEntry type="inheritedJdk"/>
</component>
XML
  end

  def test_build_xml_ruby_sdk_order_entry
    mod = create_project.java_module(random_string)

    mod.root_manager.ruby_sdk_order_entry('rbenv: 2.3.1')

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <orderEntry jdkName="rbenv: 2.3.1" jdkType="RUBY_SDK" type="jdk"/>
</component>
XML
  end

  def test_build_xml_java_sdk_order_entry
    mod = create_project.java_module(random_string)

    mod.root_manager.java_sdk_order_entry('1.8')

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <orderEntry jdkName="1.8" jdkType="JavaSDK" type="jdk"/>
</component>
XML
  end

  def test_build_xml_source_folder_order_entry
    mod = create_project.java_module(random_string)

    mod.root_manager.source_folder_order_entry

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <orderEntry forTests="false" type="sourceFolder"/>
</component>
XML
  end

  def test_module_order_entry_bad_scope
    mod = create_project.java_module(random_string)

    assert_idea_error("ModuleOrderEntry 'core-qa' attempts to set invalid scope 'NOT_TEST'") do
      mod.root_manager.module_order_entry('core-qa', :scope => 'NOT_TEST')
    end
  end

  def test_build_xml_module_order_entry
    mod = create_project.java_module(random_string)

    mod.root_manager.module_order_entry('core')
    mod.root_manager.module_order_entry('shared', :exported => true)
    mod.root_manager.module_order_entry('core-qa', :scope => 'TEST')
    mod.root_manager.module_order_entry('annotations', :scope => 'PROVIDED')

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <orderEntry module-name="core" type="module"/>
  <orderEntry exported="" module-name="shared" type="module"/>
  <orderEntry module-name="core-qa" scope="TEST" type="module"/>
  <orderEntry module-name="annotations" scope="PROVIDED" type="module"/>
</component>
XML
  end

  def test_gem_order_entry_on_non_ruby_module
    mod = create_project.java_module(random_string)

    assert_idea_error("Attempted to add gem_order_entry to non-ruby module '#{mod.name}'") do
      mod.root_manager.gem_order_entry('rake', '0.9.2.2')
    end
  end

  def test_build_xml_gem_order_entry
    mod = create_project.ruby_module(random_string)

    mod.ruby_development_kit = '2.3.1'

    mod.root_manager.gem_order_entry('rake', '0.9.2.2')
    mod.root_manager.gem_order_entry('reality-core', '1.8.0')
    mod.root_manager.gem_order_entry('reality-model', '1.3.0')

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <orderEntry level="application" name="rake (v0.9.2.2, rbenv: 2.3.1) [gem]" scope="PROVIDED" type="library"/>
  <orderEntry level="application" name="reality-core (v1.8.0, rbenv: 2.3.1) [gem]" scope="PROVIDED" type="library"/>
  <orderEntry level="application" name="reality-model (v1.3.0, rbenv: 2.3.1) [gem]" scope="PROVIDED" type="library"/>
</component>
XML
  end

  def test_java_order_entry_on_non_java_module
    mod = create_project.ruby_module(random_string)

    assert_idea_error("Attempted to add java_library_order_entry to non-java module '#{mod.name}'") do
      mod.root_manager.java_library_order_entry
    end
  end

  def test_build_xml_java_library_order_entry
    mod = create_project.java_module(random_string)

    dir = mod.module_directory
    maven_dir = File.expand_path('~/.m2/repository')

    FileUtils.mkdir_p "#{dir}/bin/classes"

    mod.root_manager.java_library_order_entry(:classes => ["#{maven_dir}/org/realityforge/zap.jar"])
    mod.root_manager.java_library_order_entry(:sources => ["#{dir}/lib/foo-sources.jar"], :classes => ["#{dir}/lib/foo.jar"], :javadocs => ["#{dir}/lib/foo-javadocs.jar"])
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/bin/classes"])
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/lib/a.jar"], :exported => true)
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/lib/b.jar"], :scope => 'TEST')
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/lib/b.jar"], :scope => 'PROVIDED', :exported => true)

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <orderEntry type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MAVEN_REPOSITORY$/org/realityforge/zap.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/foo.jar!/"/>
      </CLASSES>
      <JAVADOC>
        <root url="jar://$MODULE_DIR$/lib/foo-javadocs.jar!/"/>
      </JAVADOC>
      <SOURCES>
        <root url="jar://$MODULE_DIR$/lib/foo-sources.jar!/"/>
      </SOURCES>
    </library>
  </orderEntry>
  <orderEntry type="module-library">
    <library>
      <CLASSES>
        <root url="file://$MODULE_DIR$/bin/classes"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry exported="" type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/a.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry scope="TEST" type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/b.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry exported="" scope="PROVIDED" type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/b.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
</component>
XML
  end

  def test_build_xml_default_content_root
    mod = create_project.java_module(random_string)

    dir = mod.module_directory

    mod.root_manager.default_content_root do |c|
      c.source_folder("#{dir}/src/main/java")
      c.source_folder("#{dir}/src/main/resources", :resource => true)
      c.source_folder("#{dir}/src/test/java", :test => true)
      c.source_folder("#{dir}/src/test/resources", :test => true, :resource => true)
      c.source_folder("#{dir}/generated/src/main/java", :generated => true)
      c.source_folder("#{dir}/generated/src/main/resources", :resource => true, :generated => true)
      c.source_folder("#{dir}/generated/src/test/java", :test => true, :generated => true)
      c.source_folder("#{dir}/generated/src/test/resources", :test => true, :resource => true, :generated => true)
      c.exclude_path("#{dir}/tmp")
      c.exclude_pattern = '~*'
    end

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <content url="file://$MODULE_DIR$">
    <sourceFolder isTestSource="false" url="file://$MODULE_DIR$/src/main/java"/>
    <sourceFolder type="java-resource" url="file://$MODULE_DIR$/src/main/resources"/>
    <sourceFolder isTestSource="true" url="file://$MODULE_DIR$/src/test/java"/>
    <sourceFolder type="java-test-resource" url="file://$MODULE_DIR$/src/test/resources"/>
    <sourceFolder generated="true" isTestSource="false" url="file://$MODULE_DIR$/generated/src/main/java"/>
    <sourceFolder generated="true" type="java-resource" url="file://$MODULE_DIR$/generated/src/main/resources"/>
    <sourceFolder generated="true" isTestSource="true" url="file://$MODULE_DIR$/generated/src/test/java"/>
    <sourceFolder generated="true" type="java-test-resource" url="file://$MODULE_DIR$/generated/src/test/resources"/>
    <excludeFolder url="file://$MODULE_DIR$/tmp"/>
    <excludePattern pattern="~*"/>
  </content>
</component>
XML
  end

  def test_build_xml_multiple_roots
    mod = create_project.java_module(random_string)

    dir = mod.module_directory

    mod.root_manager.default_content_root do |c|
      c.source_folder("#{dir}/src/main/java")
    end

    mod.root_manager.content_root("#{dir}/../mypeer") do |c|
      c.source_folder("#{dir}/../mypeer/src/main/java")
    end

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <content url="file://$MODULE_DIR$">
    <sourceFolder isTestSource="false" url="file://$MODULE_DIR$/src/main/java"/>
  </content>
  <content url="file://$MODULE_DIR$/../mypeer">
    <sourceFolder isTestSource="false" url="file://$MODULE_DIR$/../mypeer/src/main/java"/>
  </content>
</component>
XML
  end

  def test_build_xml_content_root
    mod = create_project.java_module(random_string)

    dir = mod.module_directory

    mod.root_manager.default_content_root do |c|
      c.source_folder("#{dir}/src/main/java")
    end

    mod.root_manager.content_root("#{dir}/../mypeer") do |c|
      c.source_folder("#{dir}/../mypeer/src/main/java")
    end

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <content url="file://$MODULE_DIR$">
    <sourceFolder isTestSource="false" url="file://$MODULE_DIR$/src/main/java"/>
  </content>
  <content url="file://$MODULE_DIR$/../mypeer">
    <sourceFolder isTestSource="false" url="file://$MODULE_DIR$/../mypeer/src/main/java"/>
  </content>
</component>
XML
  end

  def test_standard_java_module
    mod = create_project.java_module(random_string)

    dir = mod.module_directory
    maven_dir = File.expand_path('~/.m2/repository')

    mod.root_manager.output_directory = "#{dir}/target/idea/classes"
    mod.root_manager.test_output_directory = "#{dir}/target/idea/test-classes"

    mod.root_manager.default_content_root do |c|
      c.source_folder("#{dir}/src/main/java")
      c.source_folder("#{dir}/src/main/resources", :resource => true)
      c.source_folder("#{dir}/src/test/java", :test => true)
      c.source_folder("#{dir}/src/test/resources", :test => true, :resource => true)
      c.source_folder("#{dir}/generated/src/main/java", :generated => true)
      c.source_folder("#{dir}/generated/src/main/resources", :resource => true, :generated => true)
      c.source_folder("#{dir}/generated/src/test/java", :test => true, :generated => true)
      c.source_folder("#{dir}/generated/src/test/resources", :test => true, :resource => true, :generated => true)
      c.exclude_path("#{dir}/tmp")
      c.exclude_pattern = '~*'
    end
    mod.root_manager.source_folder_order_entry
    mod.root_manager.java_sdk_order_entry('1.8')
    mod.root_manager.module_order_entry('core-qa', :exported => false, :scope => 'TEST')
    mod.root_manager.java_library_order_entry(:classes => ["#{maven_dir}/org/realityforge/zap.jar"])
    mod.root_manager.java_library_order_entry(:sources => ["#{dir}/lib/foo-sources.jar"], :classes => ["#{dir}/lib/foo.jar"], :javadocs => ["#{dir}/lib/foo-javadocs.jar"])
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/bin/classes"])
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/lib/a.jar"], :exported => true)
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/lib/b.jar"], :scope => 'TEST')
    mod.root_manager.java_library_order_entry(:classes => ["#{dir}/lib/b.jar"], :scope => 'PROVIDED', :exported => true)
    mod.root_manager.module_order_entry('core')
    mod.root_manager.module_order_entry('shared', :exported => true)

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="false" name="NewModuleRootManager">
  <output url="file://$MODULE_DIR$/target/idea/classes"/>
  <output-test url="file://$MODULE_DIR$/target/idea/test-classes"/>
  <exclude-output/>
  <content url="file://$MODULE_DIR$">
    <sourceFolder isTestSource="false" url="file://$MODULE_DIR$/src/main/java"/>
    <sourceFolder type="java-resource" url="file://$MODULE_DIR$/src/main/resources"/>
    <sourceFolder isTestSource="true" url="file://$MODULE_DIR$/src/test/java"/>
    <sourceFolder type="java-test-resource" url="file://$MODULE_DIR$/src/test/resources"/>
    <sourceFolder generated="true" isTestSource="false" url="file://$MODULE_DIR$/generated/src/main/java"/>
    <sourceFolder generated="true" type="java-resource" url="file://$MODULE_DIR$/generated/src/main/resources"/>
    <sourceFolder generated="true" isTestSource="true" url="file://$MODULE_DIR$/generated/src/test/java"/>
    <sourceFolder generated="true" type="java-test-resource" url="file://$MODULE_DIR$/generated/src/test/resources"/>
    <excludeFolder url="file://$MODULE_DIR$/tmp"/>
    <excludePattern pattern="~*"/>
  </content>
  <orderEntry forTests="false" type="sourceFolder"/>
  <orderEntry jdkName="1.8" jdkType="JavaSDK" type="jdk"/>
  <orderEntry module-name="core-qa" scope="TEST" type="module"/>
  <orderEntry type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MAVEN_REPOSITORY$/org/realityforge/zap.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/foo.jar!/"/>
      </CLASSES>
      <JAVADOC>
        <root url="jar://$MODULE_DIR$/lib/foo-javadocs.jar!/"/>
      </JAVADOC>
      <SOURCES>
        <root url="jar://$MODULE_DIR$/lib/foo-sources.jar!/"/>
      </SOURCES>
    </library>
  </orderEntry>
  <orderEntry type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/bin/classes!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry exported="" type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/a.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry scope="TEST" type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/b.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry exported="" scope="PROVIDED" type="module-library">
    <library>
      <CLASSES>
        <root url="jar://$MODULE_DIR$/lib/b.jar!/"/>
      </CLASSES>
    </library>
  </orderEntry>
  <orderEntry module-name="core" type="module"/>
  <orderEntry exported="" module-name="shared" type="module"/>
</component>
XML
  end

  def test_standard_ruby_module
    mod = create_project.ruby_module(random_string)

    dir = mod.module_directory

    mod.ruby_development_kit = '2.3.1'

    mod.root_manager.default_content_root do |c|
      c.source_folder("#{dir}/lib")
      c.source_folder("#{dir}/java", :test => true)
      c.exclude_path("#{dir}/tmp")
      c.exclude_pattern = '~*'
    end

    mod.root_manager.ruby_sdk_order_entry('rbenv: 2.3.1')
    mod.root_manager.source_folder_order_entry
    mod.root_manager.gem_order_entry('rake', '0.9.2.2')
    mod.root_manager.gem_order_entry('reality-core', '1.8.0')
    mod.root_manager.gem_order_entry('reality-model', '1.3.0')

    assert_xml_equal <<XML, component_to_xml(mod.root_manager)
<component inherit-compiler-output="true" name="NewModuleRootManager">
  <exclude-output/>
  <content url="file://$MODULE_DIR$">
    <sourceFolder isTestSource="false" url="file://$MODULE_DIR$/lib"/>
    <sourceFolder isTestSource="true" url="file://$MODULE_DIR$/java"/>
    <excludeFolder url="file://$MODULE_DIR$/tmp"/>
    <excludePattern pattern="~*"/>
  </content>
  <orderEntry jdkName="rbenv: 2.3.1" jdkType="RUBY_SDK" type="jdk"/>
  <orderEntry forTests="false" type="sourceFolder"/>
  <orderEntry level="application" name="rake (v0.9.2.2, rbenv: 2.3.1) [gem]" scope="PROVIDED" type="library"/>
  <orderEntry level="application" name="reality-core (v1.8.0, rbenv: 2.3.1) [gem]" scope="PROVIDED" type="library"/>
  <orderEntry level="application" name="reality-model (v1.3.0, rbenv: 2.3.1) [gem]" scope="PROVIDED" type="library"/>
</component>
XML
  end
end
