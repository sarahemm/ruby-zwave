require 'bundler'
Bundler.setup

require "rspec"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "zwave/version"

desc "Builds the gem"
task :gem => :build
task :build do
  system "gem1.9 build zwave.gemspec"
  Dir.mkdir("pkg") unless Dir.exists?("pkg")
  system "mv zwave-#{ZWave::VERSION}.gem pkg/"
end

task :install => :build do
  system "sudo gem1.9 install pkg/zwave-#{ZWave::VERSION}.gem"
end

desc "Release the gem - Gemcutter"
task :release => :build do
  system "git tag -a v#{ZWave::VERSION} -m 'Tagging #{ZWave::VERSION}'"
  system "git push --tags"
  system "gem push pkg/zwave-#{ZWave::VERSION}.gem"
end

task :default => [:spec]
