require "./base"

require "../../reddit/post/show"

module CyberJyrki
  module UseCase
    module Actions
      module Hears
        class Reddit < Base
          Log = ::Log.for(self)

          def call
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
              else
                reply_with_text(post)
              end
            rescue ex
              Log.error { ex }
            end
          end

          private def reply_with_image(post)
            caption = "*#{markdown_escape post.title}*\n_Posted in r/#{markdown_escape post.subreddit} by u/#{markdown_escape post.author}_"

            context.message.reply_with_photo(
              post.url,
              caption: caption,
              parse_mode: Tourmaline::ParseMode::MarkdownV2,
            )
          end

          private def reply_with_text(post)
            content = "*#{markdown_escape post.title}*\n_Posted in r/#{markdown_escape post.subreddit} by u/#{markdown_escape post.author}_\n\n#{markdown_escape post.selftext}"
            context.message.reply(content, parse_mode: Tourmaline::ParseMode::MarkdownV2)
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
