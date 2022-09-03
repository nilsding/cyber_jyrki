require "./rating"

module CyberJyrki
  module Models
    module FurAffinity
      enum Rating
        General
        Mature
        Adult
        Unknown

        def self.from(str : String)
          case str.downcase
          when "general"
            General
          when "mature"
            Mature
          when "adult"
            Adult
          else
            Unknown
          end
        end
      end
    end
  end
end
