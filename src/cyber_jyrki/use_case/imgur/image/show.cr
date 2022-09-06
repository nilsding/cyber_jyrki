require "../show_base"
require "../../../models/imgur/image"

require "json"

module CyberJyrki
  module UseCase
    module Imgur
      module Image
        class Show < ShowBase(Models::Imgur::Image)
        end
      end
    end
  end
end
