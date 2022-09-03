require "./base"

require "../../fur_affinity/post/show"

module CyberJyrki
  module UseCase
    module Actions
      module Hears
        class FurAffinity < Base
          Log = ::Log.for(self)

          def call
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

            if post.url.downcase.ends_with?(".gif") # likely to be an animated gif
              context.message.reply_with_animation(
                post.url,
                caption: caption,
                parse_mode: Tourmaline::ParseMode::MarkdownV2,
              )

              return
            end

            context.message.reply_with_photo(
              post.url,
              caption: caption,
              parse_mode: Tourmaline::ParseMode::MarkdownV2,
            )
          end

          # "please note" https://core.telegram.org/bots/api#markdownv2-style
          private def markdown_escape(text)
            text
              .gsub("_", "\\_")
              .gsub("*", "\\*")
              .gsub("[", "\\[")
              .gsub("]", "\\]")
              .gsub("(", "\\(")
              .gsub(")", "\\)")
              .gsub("~", "\\~")
              .gsub("`", "\\`")
              .gsub(">", "\\>")
              .gsub("#", "\\#")
              .gsub("+", "\\+")
              .gsub("-", "\\-")
              .gsub("=", "\\=")
              .gsub("|", "\\|")
              .gsub("{", "\\{")
              .gsub("}", "\\}")
              .gsub(".", "\\.")
              .gsub("!", "\\!")
          end
        end
      end
    end
  end
end
