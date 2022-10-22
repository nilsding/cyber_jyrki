require "./base"

require "../../reddit/post/show"
require "../../imgur/album/show"

require "uri"

module CyberJyrki
  module UseCase
    module Actions
      module Hears
        class Reddit < Base
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
              post = UseCase::Reddit::Post::Show.call(post_id)

              if post.image?
                reply_with_image(post)
              elsif post.url =~ %r{://(?:www\.)?imgur\.com/a/\S+}
                reply_with_imgur_album(post)
              else
                reply_with_text(post)
              end
            rescue ex
              Log.error { ex }
            end
          end

          private def reply_with_image(post)
            caption = base_caption(post)

            reply_to_message_with_image(context.message, image_url: post.url, caption: caption)
          end

          private def reply_with_imgur_album(post)
            caption = base_caption(post)

            imgur_uri = URI.parse(post.url)
            path_parts = imgur_uri.path.split("/").reject(&.empty?)
            return reply_with_link(post) if path_parts.empty?

            album_id = path_parts.last
            album = UseCase::Imgur::Album::Show.call(album_id)
            return reply_with_link(post) if album.images.empty?

            image_urls = album.images.reject(&.ad?).map(&.link)
            reply_to_message_with_album(
              context.message,
              image_urls: image_urls,
              caption: caption
            )
          rescue ex
            Log.error { "got #{ex} (#{ex.class} while trying to reply with imgur album #{post.url}, just posting the link ..." }
            reply_with_link(post)
          end

          private def reply_with_link(post)
            content = "#{base_caption(post)}\n\n#{markdown_escape post.url}"
            context.message.reply(content, parse_mode: Tourmaline::ParseMode::MarkdownV2)
          end

          private def reply_with_text(post)
            content = "#{base_caption(post)}\n\n#{markdown_escape post.selftext}"
            context.message.reply(content, parse_mode: Tourmaline::ParseMode::MarkdownV2)
          end

          private def base_caption(post)
            "*#{markdown_escape post.title}*\n_Posted in r/#{markdown_escape post.subreddit} by u/#{markdown_escape post.author}_"
          end
        end
      end
    end
  end
end
