require "../base"

require "tourmaline"

module CyberJyrki
  module UseCase
    module Actions
      abstract class Base < UseCase::Base
        getter context

        def initialize(@context : Tourmaline::Handlers::CommandHandler::Context)
        end

        abstract def call
      end
    end
  end
end
