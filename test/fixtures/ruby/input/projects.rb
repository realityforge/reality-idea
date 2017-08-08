project_directory = File.expand_path(File.dirname(__FILE__))

Reality::Idea.project('reality-core', :project_directory => project_directory) do |p|
  p.ruby_module('reality-core', :module_directory => project_directory) do |m|
    m.settings.load_path << "#{m.module_directory}/lib"
    m.settings.load_path << "#{m.module_directory}/test"
  end
end
