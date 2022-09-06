require "../show_base"
require "../../../models/imgur/album"

require "json"

module CyberJyrki
  module UseCase
    module Imgur
      module Album
        class Show < ShowBase(Models::Imgur::Album)
        end
      end
    end
  end
end
