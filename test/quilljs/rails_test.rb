require 'test_helper'

class Quilljs::RailsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Quilljs::Rails::VERSION
  end

  def test_gem_name_and_author_updated
    gemspec = File.read(File.expand_path('../../quilljs-rails.gemspec', __dir__))
    assert_includes gemspec, 'quilljs2-rails', 'Gemspec should use the new gem name indicating Quill 2 support'
    assert_includes gemspec, 'Sajjad Umar', 'Gemspec should list Sajjad Umar as the author'
    readme = File.read(File.expand_path('../../README.md', __dir__))
    assert_includes readme, 'maintained fork of the original quilljs-rails', 'README should mention this is a fork of the original'
    assert_includes readme, "gem 'quilljs2-rails'", 'README installation should use the new gem name'
  end

  def test_default_require_file_exists
    # Ensure requiring by gem name works in host apps
    assert require('quilljs2-rails'), 'Requiring quilljs2-rails should succeed'
    assert defined?(::Quilljs::Rails), 'Quilljs::Rails should be defined after requiring the gem entrypoint'
  end
end
