require "json"

require "./image"

module CyberJyrki
  module Models
    module Imgur
      class Album
        include JSON::Serializable

        property id : String
        property title : String?
        property description : String?
        @[JSON::Field(converter: Time::EpochConverter)]
        property datetime : Time
        property link : String
        property is_ad : Bool
        property images : Array(Image)

        def ad? : Bool
          is_ad
        end
      end
    end
  end
end
