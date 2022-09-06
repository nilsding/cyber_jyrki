require "../base"

module CyberJyrki
  module UseCase
    module Actions
      abstract class Base < UseCase::Base
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

        # tries to reply to a message with a given image
        #
        # make sure `caption` is properly escaped
        private def reply_to_message_with_image(message, image_url : String, caption : String)
          image_url_downcase = image_url.downcase
          is_animation = image_url_downcase.ends_with?(".gif") # likely to be an animated gif

          # imgur workarounds
          if image_url_downcase =~ %r{://i.imgur.com/}
            image_url = image_url.gsub(/\.gifv$/i, ".gif") # ensure we use .gif instead of .gifv (some html) extension

            # replace ".gif" with ".mp4" as it's more efficient
            if image_url_downcase.ends_with?(".gif")
              image_url = image_url.gsub(/\.gif$/i, ".mp4")
              is_animation = true
            end
          end

          if is_animation
            context.message.reply_with_animation(
              image_url,
              caption: caption,
              parse_mode: Tourmaline::ParseMode::MarkdownV2,
            )

            return
          end

          context.message.reply_with_photo(
            image_url,
            caption: caption,
            parse_mode: Tourmaline::ParseMode::MarkdownV2,
          )
        rescue ex
          ::Log.for(self.class).warn { "got #{ex} (#{ex.class}) while trying to send #{image_url}, sending the image url" }
          context.message.reply("#{markdown_escape image_url}\n\n" + caption, parse_mode: Tourmaline::ParseMode::MarkdownV2)
        end
      end
    end
  end
end
