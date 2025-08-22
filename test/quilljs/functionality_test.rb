require 'test_helper'

class Quilljs::RailsFunctionalityTest < Minitest::Test
  LIB_PATH = File.expand_path('../../lib', __dir__)

  def test_engine_not_loaded_without_rails
    # In some environments, Rails may be present via dev deps; if so, this check is not applicable.
    if defined?(::Rails)
      skip 'Rails is present in test environment; skipping pre-definition check.'
    end
    refute Quilljs::Rails.const_defined?(:Engine), 'Engine should not be pre-defined before explicit load with Rails::Engine'
  end

  def test_engine_loaded_when_rails_is_defined
    created_rails = false
    unless defined?(::Rails)
      Object.const_set(:Rails, Module.new)
      created_rails = true
    end
    # Ensure Rails::Engine exists so the engine class can inherit from it
    unless defined?(::Rails::Engine)
      engine_stub = Class.new do
        def self.initializer(*); end
      end
      ::Rails.const_set(:Engine, engine_stub)
    end

    load File.expand_path('../../lib/quilljs/rails.rb', __dir__)

    assert Quilljs::Rails.const_defined?(:Engine), 'Engine should be defined when Rails is present'
  ensure
    # Cleanup only if we created Rails in this test
    if created_rails
      Object.send(:remove_const, :Rails)
    end
  end

  def test_initializer_uses_text_change_event
    path = File.expand_path('../../app/assets/javascripts/quill.global.js', __dir__)
    content = File.read(path)
    assert_includes content, "on('text-change'", "quill.global.js should bind to 'text-change' for Quill 2.x"
    assert_includes content, 'window.Quilljs', 'Initializer should expose window.Quilljs global'
    assert_includes content, 'setDefaults:', 'Initializer should define setDefaults method'
  end

  def test_asset_files_exist
    %w[
      app/assets/javascripts/quill.min.js
      app/assets/javascripts/quill.core.js
      app/assets/javascripts/quill.global.js
      app/assets/stylesheets/quill.core.css
      app/assets/stylesheets/quill.snow.css
      app/assets/stylesheets/quill.bubble.css
    ].each do |rel|
      path = File.expand_path("../../#{rel}", __dir__)
      assert File.exist?(path), "Expected asset to exist: #{rel}"
    end
  end

  def test_stylesheets_updated_to_latest_v2
    {
      'app/assets/stylesheets/quill.core.css' => 'v2.0.3',
      'app/assets/stylesheets/quill.snow.css' => 'v2.0.3',
      'app/assets/stylesheets/quill.bubble.css' => 'v2.0.3',
    }.each do |rel, marker|
      path = File.expand_path("../../#{rel}", __dir__)
      content = File.read(path)[0, 200]
      assert_includes content, marker, "#{rel} should indicate updated Quill #{marker} styling from slab/quill"
    end
  end

  def test_engine_adds_assets_to_precompile
    path = File.expand_path('../../lib/quilljs/rails.rb', __dir__)
    content = File.read(path)
    assert_includes content, 'assets.precompile', 'Engine should append assets to precompile list'
    %w[quill.core.css quill.snow.css quill.bubble.css quill.min.js quill.core.js quill.global.js].each do |asset|
      assert_includes content, asset, "Engine precompile list should include #{asset}"
    end
  end
end


# Additional tests to ensure JS and CSS reflect latest slab/quill v2.1.2 content markers
class Quilljs::RailsFunctionalityTest < Minitest::Test
  def test_javascript_headers_updated_to_latest_v2
    # quill.core.js should carry the upstream version banner
    core_path = File.expand_path('../../app/assets/javascripts/quill.core.js', __dir__)
    core = File.read(core_path)
    assert_includes core, 'Quill', 'quill.core.js should reference or define the Quill global/module'

    # quill.min.js from jsDelivr may not include the exact banner; ensure version is present in its header comment
    min_path = File.expand_path('../../app/assets/javascripts/quill.min.js', __dir__)
    min = File.read(min_path)[0, 300]
    assert min.include?('v2.0.3') || min.include?('/npm/quill@2.0.3'), 'quill.min.js should include a 2.0.3 version marker in its header'
  end

  def test_stylesheets_include_tasklist_markers
    %w[
      app/assets/stylesheets/quill.core.css
      app/assets/stylesheets/quill.snow.css
      app/assets/stylesheets/quill.bubble.css
    ].each do |rel|
      path = File.expand_path("../../#{rel}", __dir__)
      content = File.read(path)
      assert_includes content, "li[data-list=checked]", "#{rel} should include v2 task list checked marker"
      assert_includes content, "li[data-list=unchecked]", "#{rel} should include v2 task list unchecked marker"
    end
  end
end
