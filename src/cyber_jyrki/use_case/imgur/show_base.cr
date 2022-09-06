require "./base"
require "../../models/imgur/api_response"

require "crest"

module CyberJyrki
  module UseCase
    module Imgur
      class ShowBase(T) < Base
        getter id : String

        def initialize(@id)
        end

        def call
          response = Crest.get(
            "#{IMGUR_BASE_URL}/3/#{api_type}/#{id}",
            headers: IMGUR_BASE_HEADERS,
            user_agent: USER_AGENT,
            json: true
          )
          parsed_response = Models::Imgur::ApiResponse(T).from_json(response.body)
          parsed_response.data
        end

        # returns the api type depending on T
        # e.g. Models::Imgur::Album returns "album"
        private def api_type : String
          {{ T.name.split("::").last.downcase }}
        end
      end
    end
  end
end
