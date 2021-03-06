require_relative 'lib/vtiger-ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'vtiger-ruby'
  spec.version       = VtigerRuby::VERSION
  spec.authors       = ["Yedidia Muk'mar"]
  spec.summary       = 'Vtiger API Ruby SDK'
  spec.description   = 'Vtiger API Library for Ruby applications'
  spec.homepage      = 'https://github.com/ymukmar/vtiger-ruby'

  spec.required_ruby_version = '>= 2.5.1'

  spec.add_runtime_dependency 'faraday', '~> 1.0.1'
  spec.add_runtime_dependency 'json', '~> 2.3'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'webmock', '~> 3.9'

  spec.files = `find *`.split("\n").uniq.sort
  spec.executables   = []
  spec.require_paths = ['lib']
end
