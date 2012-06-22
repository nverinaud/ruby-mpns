# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "ruby-mpns"
  gem.homepage = "http://github.com/nverinaud/ruby-mpns"
  gem.license = "MIT"
  gem.summary = %Q{A ruby gem to communicate with Microsoft Push Notification Service.}
  gem.description = %Q{This gem provides an easy way to send push notifications to Windows Phone devices using Microsoft Push Notification Service.}
  gem.email = "n.verinaud@gmail.com"
  gem.authors = ["Nicolas VERINAUD"]
  gem.add_dependency 'htmlentities'
  gem.files.exclude 'sample' # exclude sample directory
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-mpns #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
