require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "app_config_mt"
    gem.summary = %Q{Application level configuration.}
    gem.description = %Q{Application level configuration that supports YAML config file, inheritance, ERB, and object member notation.}
    gem.email = "mannie@mygrid.org.uk"
    gem.homepage = "http://github.com/myGrid/app_config"
    gem.authors = ["Mannie Tagarira"]

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the app_config plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

