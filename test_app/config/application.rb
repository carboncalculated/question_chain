require File.expand_path('../boot', __FILE__)

require "active_support/railtie"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require :default, Rails.env

module TestApp
  class Application < Rails::Application

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
    config.encoding = "utf-8"
    config.cache_classes = true
  end
end
