require "./base"

require "../../fur_affinity/post/show"

module CyberJyrki
  module UseCase
    module Actions
      module Hears
        class FurAffinity < Base
          Log = ::Log.for(self)

          def call
            if attachments?(context.message)
              # assume the attachment is the content -- no need to try to fetch it ourselves
              from_id = if context.message.from
                          context.message.from.not_nil!.id.to_s
                        else
                          "<unknown user>"
                        end
              Log.info { "ignoring message from #{from_id} as it has attachments" }
              return
            end

            post_id = context.match["post_id"]
            if post_id.nil?
              Log.info { "no post id found in #{context.message.text}" }
              return
            end

            Log.info { "looking up post #{post_id}" }
            begin
              post = UseCase::FurAffinity::Post::Show.call(post_id)

              unless post.valid?
                Log.warn { "#{post_id} is not a valid post" }
                return
              end

              unless post.image?
                Log.info { "#{post_id} is not an image post (download url is: #{post.url.inspect})" }
                return
              end

              reply_with_image(post)
            rescue ex
              Log.error { ex }
            end
          end

          private def reply_with_image(post)
            caption = "*#{markdown_escape post.title}*\n_by #{markdown_escape post.artist}, #{markdown_escape post.rating.to_s} rating_"

            reply_to_message_with_image(context.message, image_url: post.url, caption: caption)
          end
        end
      end
    end
  end
end
