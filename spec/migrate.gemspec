# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'migrate/version'

Gem::Specification.new do |s|
  s.name        = 'migrate'
  s.version     = Migrate::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Aubrey Holland']
  s.email       = ['aubreyholland@gmail.com']
  s.homepage    = 'http://github.com/aub/migrate'
  s.summary     = %q{A universal data migration framework}
  s.description = %q{}

  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'migrate'

  s.add_development_dependency 'ronn'
  s.add_development_dependency 'rspec', '~> 2.0'

  # Man files are required because they are ignored by git
  man_files            = Dir.glob('lib/migrate/man/**/*')
  git_files            = `git ls-files`.split("\n") rescue ''
  s.files              = git_files + man_files
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables        = %w(migrate)
  s.require_paths      = %w(lib)
end
