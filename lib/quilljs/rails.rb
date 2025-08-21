require "quilljs/rails/version"

module Quilljs
  module Rails
    if defined?(::Rails)
      class Engine < ::Rails::Engine
        initializer 'quilljs.assets.precompile' do |app|
          if app.config.respond_to?(:assets) && app.config.assets.respond_to?(:precompile)
            app.config.assets.precompile += %w[
              quill.core.css
              quill.snow.css
              quill.bubble.css
              quill.min.js
              quill.core.js
              quill.global.js
            ]
          end
        end
      end
    end
  end
end