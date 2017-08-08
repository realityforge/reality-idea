project_directory = File.expand_path(File.dirname(__FILE__))
maven_dir = File.expand_path('~/.m2/repository')

Reality::Idea.project('acal', :project_directory => project_directory) do |p|
  p.java_module('annotations') do |m|
    m.root_manager.java_sdk_order_entry('1.8')
    m.root_manager.output_directory = "#{m.module_directory}/target/classes"
    m.root_manager.test_output_directory = "#{m.module_directory}/target/test-classes"

    m.root_manager.java_library_order_entry(:classes => ["#{maven_dir}/org/realityforge/annotations.jar"], :scope => 'PROVIDED', :exported => true)

    m.root_manager.default_content_root do |c|
      c.source_folder("#{m.module_directory}/src/main/java")
      c.source_folder("#{m.module_directory}/src/main/resources", :resource => true)
      c.source_folder("#{m.module_directory}/src/test/java", :test => true)
      c.source_folder("#{m.module_directory}/src/test/resources", :test => true, :resource => true)
    end
  end

  p.java_module('core') do |m|
    m.root_manager.java_sdk_order_entry('1.8')
    m.root_manager.output_directory = "#{m.module_directory}/target/classes"
    m.root_manager.test_output_directory = "#{m.module_directory}/target/test-classes"

    m.root_manager.java_library_order_entry(:sources => ["#{m.module_directory}/lib/foo-sources.jar"], :classes => ["#{m.module_directory}/lib/foo.jar"], :javadocs => ["#{m.module_directory}/lib/foo-javadocs.jar"])
    m.root_manager.java_library_order_entry(:classes => ["#{m.module_directory}/lib/classes"])
    m.root_manager.module_order_entry('annotations', :scope => 'PROVIDED')

    m.root_manager.default_content_root do |c|
      c.source_folder("#{m.module_directory}/src/main/java")
      c.source_folder("#{m.module_directory}/src/main/resources", :resource => true)
      c.source_folder("#{m.module_directory}/src/test/java", :test => true)
      c.source_folder("#{m.module_directory}/src/test/resources", :test => true, :resource => true)
      c.source_folder("#{m.module_directory}/generated/src/main/java", :generated => true)
      c.source_folder("#{m.module_directory}/generated/src/main/resources", :resource => true, :generated => true)
      c.source_folder("#{m.module_directory}/generated/src/test/java", :test => true, :generated => true)
      c.source_folder("#{m.module_directory}/generated/src/test/resources", :test => true, :resource => true, :generated => true)
      c.exclude_path("#{m.module_directory}/tmp")
    end
  end
end
