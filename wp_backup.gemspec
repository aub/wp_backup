# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'wp_backup/version'

Gem::Specification.new do |s|
  s.name        = 'wp_backup'
  s.version     = WpBackup::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Aubrey Holland']
  s.email       = ['aubreyholland@gmail.com']
  s.homepage    = 'http://github.com/aub/wp_backup'
  s.summary     = %q{A tool for backing up wordpress blogs to s3}
  s.description = %q{}

  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'wp_backup'

  s.add_development_dependency 'ronn'
  s.add_development_dependency 'rspec', '~> 2.0'

  # Man files are required because they are ignored by git
  man_files            = Dir.glob('lib/wp_backup/man/**/*')
  git_files            = `git ls-files`.split("\n") rescue ''
  s.files              = git_files + man_files
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables        = %w(wp_backup)
  s.require_paths      = %w(lib)
end
