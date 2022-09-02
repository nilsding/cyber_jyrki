require "json"

module CyberJyrki
  module Models
    module Reddit
      # represents a reddit thread
      class Post
        include JSON::Serializable

        property subreddit : String
        property selftext : String
        property title : String
        property author : String
        property post_hint : String?
        property is_self : Bool
        property permalink : String
        property url : String

        def self?
          is_self
        end

        def image?
          !self? && post_hint == "image"
        end
      end
    end
  end
end
