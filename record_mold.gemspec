# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "record_mold"
  spec.version       = '0.1.1'
  spec.authors       = ["Kenji Gonnokami"]
  spec.email         = ["amatsukikuu@gmail.com"]
  spec.description   = 'Provide validations from ActiveRecord schema information.'
  spec.summary       = 'A module that provides validations from ActiveRecord schema information.'
  spec.homepage      = 'https://github.com/AmatsukiKu/record_mold'
  spec.license       = "WTFPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # spec.add_dependency 'railties'
  spec.add_dependency 'activerecord'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'pg'
end

