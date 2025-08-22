# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quilljs/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "quilljs2-rails"
  spec.version       = Quilljs::Rails::VERSION
  spec.authors       = ["Sajjad Umar"]
  spec.email         = ["sajjadumardev@gmail.com"]

  spec.summary       = %q{Rails assets and helper for Quill rich text editor (2.x, TypeScript-authored upstream)}
  spec.description   = 'Maintained fork of abhinavmathur/quilljs-rails updated for Quill 2.x. Upstream is authored in TypeScript; this gem vendors the official dist (UMD) assets for Sprockets and provides a small global initializer. For modern bundlers and TypeScript, prefer installing quill from npm.'
  spec.homepage      = 'https://github.com/sumar7/quilljs-rails'
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split("\n")
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => spec.homepage + "#changelog",
    "rubygems_mfa_required" => "true"
  }

  spec.executables   = []
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.1.3'

  spec.add_development_dependency 'bundler', '>= 2.2'
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency 'jquery-rails', '~> 4.1'

end
