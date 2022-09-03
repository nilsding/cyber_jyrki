require "../../base"
require "../../../models/fur_affinity/post"
require "../../../models/fur_affinity/rating"

require "crest"
require "html5"

module CyberJyrki
  module UseCase
    module FurAffinity
      module Post
        class Show < UseCase::Base
          FUR_AFFINITY_BASE_URL     = "https://furaffinity.net"
          FUR_AFFINITY_BASE_COOKIES = {
            "a" => ENV.fetch("FUR_AFFINITY_COOKIE_A"),
            "b" => ENV.fetch("FUR_AFFINITY_COOKIE_B"),
          }
          USER_AGENT = "CyberJyrki/#{VERSION} (https://github.com/nilsding/cyber_jyrki)"

          Log = ::Log.for(self)

          getter post_id : String

          def initialize(@post_id)
          end

          def call
            response = Crest.get(
              "#{FUR_AFFINITY_BASE_URL}/view/#{post_id}/",
              cookies: FUR_AFFINITY_BASE_COOKIES,
              user_agent: USER_AGENT,
            )

            Log.info { "parsing response from FA" }
            doc = HTML5.parse(response.body)

            Log.info { "extracting information" }
            title = extract_text(doc, ".submission-title")
            artist = extract_text(doc, ".submission-id-container a strong")
            rating_str = extract_text(doc, ".rating-box")
            url = extract_href(doc, ".buttons .download a")
            url = "https:#{url}" if url.starts_with?("//")

            Models::FurAffinity::Post.new(
              title: title,
              artist: artist,
              url: url,
              rating: Models::FurAffinity::Rating.from(rating_str),
            )
          end

          private def extract_text(doc, css) : String
            nodes = doc.css(css)
            return "" if nodes.empty?

            elem = nodes.first
            return "" if elem.nil?

            elem.inner_text.strip
          end

          private def extract_href(doc, css) : String
            nodes = doc.css(css)
            return "" if nodes.empty?

            elem = nodes.first
            return "" if elem.nil?

            elem["href"].val
          end
        end
      end
    end
  end
end
