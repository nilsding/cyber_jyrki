require "../base"

require "tourmaline"

module CyberJyrki
  module UseCase
    module Actions
      module Hears
        abstract class Base < Actions::Base
          getter context

          def initialize(@context : Tourmaline::Handlers::HearsHandler::Context)
          end

          abstract def call
        end
      end
    end
  end
end
