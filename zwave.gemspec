# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'zwave/version'

Gem::Specification.new do |s|
  s.name = "zwave"
  s.version = ZWave::VERSION

  s.description = "Interface library for ZWave home automation devices"
  s.homepage = "http://github.com/sarahemm/ruby-zwave"
  s.summary = "ZWave interface library"
  s.licenses = "MIT"
  s.authors = ["sarahemm"]
  s.email = "zwave@sen.cx"
  
  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.md Rakefile)
  s.require_path = "lib"

  s.rubygems_version = "1.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.add_dependency("serialport", ["~> 1.2"])
end
