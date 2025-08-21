require "quilljs/rails/version"

module Quilljs
  module Rails
    if defined?(::Rails)
      class Engine < ::Rails::Engine
      end
    end
  end
end