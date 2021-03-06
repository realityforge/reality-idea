# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name               = %q{reality-idea}
  s.version            = '1.0.0'
  s.platform           = Gem::Platform::RUBY

  s.authors            = ['Peter Donald']
  s.email              = %q{peter@realityforge.org}

  s.homepage           = %q{https://github.com/realityforge/reality-idea}
  s.summary            = %q{An model representing intellij idea project files.}
  s.description        = %q{An model representing intellij idea project files.}

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.executables        = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths      = %w(lib)

  s.rdoc_options       = %w(--line-numbers --inline-source --title reality-idea)

  s.add_dependency 'reality-core', '>= 1.8.0'
  s.add_dependency 'reality-model', '>= 1.3.0'
  s.add_dependency 'builder', '= 3.2.2'

  s.add_development_dependency 'nokogiri', '= 1.7.2'
  s.add_development_dependency 'tdiff', '= 0.3.4'
  s.add_development_dependency 'nokogiri-diff', '= 0.2.0'

  s.add_development_dependency(%q<minitest>, ['= 5.9.1'])
  s.add_development_dependency(%q<test-unit>, ['= 3.1.5'])
end
