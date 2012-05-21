# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)

task :release => %w(man:clean man:build)

require 'rspec/core/rake_task'
require 'ronn'

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fs --color)
  t.ruby_opts  = %w(-w)
end
task :spec => "man:build"

task :default => :spec
