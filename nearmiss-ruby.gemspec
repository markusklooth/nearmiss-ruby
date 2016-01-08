Gem::Specification.new do |s|
  s.name              = %q{ruby-nearmiss}
  s.version           = "1.4.1"
  s.platform          = Gem::Platform::RUBY
  s.license           = 'MIT'

  s.authors           = ["Markus Klooth"]
  s.date              = Time.now.strftime "%Y-%m-%d"
  s.description       = %q{A wrapper around the nearmissapp.com API.}
  s.email             = %q{support@nearmissapp.com}
  s.extra_rdoc_files  = ["README.md"]
  s.files             = `git ls-files -z`.split("\x0")
  s.executables       = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.homepage          = %q{https://github.com/nearmiss/ruby-nearmiss}
  s.rdoc_options      = ["--charset=UTF-8"]
  s.require_paths     = ["lib"]
  s.rubyforge_project = %q{ruby-nearmiss}
  s.rubygems_version  = %q{1.0.0}
  s.summary           = %q{A wrapper around the nearmiss.com API.}
  s.test_files        = Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activemodel', '>= 3.2.0'
  s.add_dependency 'json'
  # s.add_dependency 'oauth',       '~> 0.4.5'
  s.add_dependency 'rest-client', '~> 1.8.0'
end
