# == Default requires
require 'rubygems'
require "crack"
require "hashie"
require "mustache"
require "calculated"

# == Carbon cal specific
require "question_chain/mongo_serialization"
require "question_chain/state_machine"
require "question_chain/mustache_handler"
require "question_chain/stored_template"
require "question_chain/mustache_rails"
require "question_chain/answerable"

# == Answers Controller
require "question_chain/answers"

module QuestionChain
  class Engine < Rails::Engine
    
    config.carbon_calculated = ActiveSupport::OrderedOptions.new
    config.paths["app/controller"] << "lib/question_chain/controllers"
    config.paths["app/views"] << "lib/question_chain/views"
    config.paths["app/models"] << "lib/question_chain/models"    
    config.after_initialize do
      QuestionChain.class_eval do
        def self.calculated_session
           @calculated_session ||= Rails.application.class.to_s.gsub(/::.*/,"").constantize.calculated_session
         end
      end
    end
  end
end
