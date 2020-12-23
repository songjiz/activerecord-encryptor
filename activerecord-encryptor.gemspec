require_relative 'lib/active_record/encryptor/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-encryptor"
  spec.version       = ActiveRecord::Encryptor::VERSION
  spec.authors       = ["zsj"]
  spec.email         = ["lekyzsj@gmail.com"]

  spec.summary       = %q{ActiveRecord attributes encryption.}
  spec.description   = %q{ActiveRecord attributes encryption.}
  spec.homepage      = "https://github.com/songjiz/activerecord-encryptor"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", ">= 5.2.4.3"
  spec.add_development_dependency "sqlite3"
end
