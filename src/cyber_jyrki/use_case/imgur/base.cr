require "../base"

module CyberJyrki
  module UseCase
    module Imgur
      class Base < UseCase::Base
        IMGUR_BASE_URL     = "https://api.imgur.com"
        IMGUR_BASE_HEADERS = {
          "authorization" => "Client-ID #{ENV.fetch("IMGUR_CLIENT_ID")}",
        }
      end
    end
  end
end
