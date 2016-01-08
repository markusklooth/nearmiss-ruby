# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nearmiss-ruby/version'

Gem::Specification.new do |s|
  s.name              = %q{nearmiss-ruby}
  s.version           = Nearmiss::VERSION.dup
  s.platform          = Gem::Platform::RUBY
  s.license           = 'MIT'

  s.authors           = ["Markus Klooth"]
  s.date              = Time.now.strftime "%Y-%m-%d"
  s.description       = %q{A wrapper around the nearmissapp.com API.}
  s.email             = %q{support@nearmissapp.com}
  s.extra_rdoc_files  = ["README.md"]
  s.files             = `git ls-files -z`.split("\x0")
  s.executables       = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.homepage          = %q{https://github.com/nearmiss/nearmiss-ruby}
  s.rdoc_options      = ["--charset=UTF-8"]
  s.require_paths     = ["lib"]
  s.rubyforge_project = %q{nearmiss-ruby}
  s.rubygems_version  = %q{1.3.5}
  s.summary           = %q{A wrapper around the nearmiss.com API.}
  s.test_files        = Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency("sawyer", ">= 0.5.5")
  s.add_dependency("multi_json", '>= 1.3.0')

  s.add_development_dependency 'bundler', '~> 1.0'
end
