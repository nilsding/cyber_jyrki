require "./rating"

module CyberJyrki
  module Models
    module FurAffinity
      class Post
        IMAGE_FILE_TYPES = %w[
          bmp
          gif
          jpeg
          jpg
          png
        ]

        property title : String
        property artist : String
        property url : String
        property rating : Rating

        def initialize(@title, @artist, @url, @rating)
        end

        def image? : Bool
          IMAGE_FILE_TYPES.each do |ft|
            return true if url.downcase.ends_with?(".#{ft}")
          end

          false
        end

        def valid? : Bool
          !(title.empty? || artist.empty? || url.empty? || rating.unknown?)
        end
      end
    end
  end
end
