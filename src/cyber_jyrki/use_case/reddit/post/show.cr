require "../../base"
require "../../../models/reddit/post"

require "crest"
require "json"

module CyberJyrki
  module UseCase
    module Reddit
      module Post
        class Show < UseCase::Base
          REDDIT_BASE_URL = "https://www.reddit.com"

          getter post_id : String

          def initialize(@post_id)
          end

          def call
            response = Crest.get("#{REDDIT_BASE_URL}/by_id/t3_#{post_id}.json", user_agent: USER_AGENT, json: true)

            parsed_response = JSON.parse(response.body)
            # layout of parsed_response:
            # {
            #   kind: "Listing",
            #   data: {
            #     children: [
            #       {
            #         kind: "t3",
            #         data: {
            #           subreddit: "gfur",
            #           title: "(SigmaX)",
            #           author: "justuraveragefurry",
            #           post_hint: "image",
            #           is_self: false,
            #           permalink: "/r/gfur/comments/x3gq5u/sigmax/"
            #           url: "https://i.redd.it/5rvi43e5xal91.png"
            #         }
            #       }
            #     ]
            #   }
            # }

            listing = parsed_response
            first_listing_child = listing["data"]["children"][0]
            kind = first_listing_child["kind"]
            raise "listing kind was not t3, but #{kind}" unless kind == "t3"

            Models::Reddit::Post.from_json(first_listing_child["data"].to_json) # inefficient but whatever
          end
        end
      end
    end
  end
end
