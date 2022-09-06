require "json"

module CyberJyrki
  module Models
    module Imgur
      class ApiResponse(T)
        include JSON::Serializable

        property data : T
        property success : Bool
        property status : Int64
      end
    end
  end
end
