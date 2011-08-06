$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'polymorphic_identity/version'

Gem::Specification.new do |s|
  s.name              = "polymorphic_identity"
  s.version           = PolymorphicIdentity::VERSION
  s.authors           = ["Aaron Pfeifer"]
  s.email             = "aaron@pluginaweek.org"
  s.homepage          = "http://www.pluginaweek.org"
  s.description       = "Dynamically generates aliases for polymorphic ActiveRecord associations based on their class names"
  s.summary           = "Easy aliases for polymorphic associations in ActiveRecord"
  s.require_paths     = ["lib"]
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- test/*`.split("\n")
  s.rdoc_options      = %w(--line-numbers --inline-source --title polymorphic_identity --main README.rdoc)
  s.extra_rdoc_files  = %w(README.rdoc CHANGELOG.rdoc LICENSE)
end
