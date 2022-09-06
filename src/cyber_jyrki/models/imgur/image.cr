require "json"

module CyberJyrki
  module Models
    module Imgur
      class Image
        include JSON::Serializable

        property id : String
        property title : String?
        property description : String?
        @[JSON::Field(converter: Time::EpochConverter)]
        property datetime : Time
        property type : String
        property animated : Bool
        property width : Int64
        property height : Int64
        property size : Int64
        property views : Int64
        property is_ad : Bool
        property link : String

        def ad? : Bool
          is_ad
        end
      end
    end
  end
end
