lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/wiki_search/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruboty-wiki_search'
  spec.version       = Ruboty::WikiSearch::VERSION
  spec.authors       = %w(kimromi)
  spec.email         = %w(kimromi4@gmail.com)

  spec.summary       = %q{GitHub wiki search for Ruboty}
  spec.description   = %q{GitHub wiki search for Ruboty}
  spec.homepage      = 'https://github.com/kimromi/ruboty-wiki_search'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ruboty'
  spec.add_dependency 'git'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'dotenv'
end
