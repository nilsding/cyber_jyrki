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
        private def reply_to_message_with_image(message, image_url : String, caption : String) : Tourmaline::Message
          image_url_downcase = image_url.downcase
          is_animation = image_url_downcase.ends_with?(".gif") # likely to be an animated gif

          # imgur workarounds
          if image_url_downcase =~ %r{://i\.imgur\.com/}
            image_url = image_url.gsub(/\.gifv$/i, ".gif") # ensure we use .gif instead of .gifv (some html) extension

            # replace ".gif" with ".mp4" as it's more efficient
            if image_url_downcase.ends_with?(".gif")
              image_url = image_url.gsub(/\.gif$/i, ".mp4")
              is_animation = true
            end
          end

          if is_animation
            return message.reply_with_animation(
              image_url,
              caption: caption,
              parse_mode: Tourmaline::ParseMode::MarkdownV2,
            )
          end

          message.reply_with_photo(
            image_url,
            caption: caption,
            parse_mode: Tourmaline::ParseMode::MarkdownV2,
          )
        rescue ex
          ::Log.for(self.class).warn { "got #{ex} (#{ex.class}) while trying to send #{image_url}, sending the image url" }
          message.reply("#{markdown_escape image_url}\n\n" + caption, parse_mode: Tourmaline::ParseMode::MarkdownV2)
        end

        # tries to reply to a message with a given set of images
        private def reply_to_message_with_album(message, image_urls : Array(String), caption : String)
          return if image_urls.empty?
          return reply_to_message_with_image(message, image_urls.first, caption) if image_urls.size == 1

          # this will be set to nil after the first url
          first_caption : String? = caption
          last_message = message

          image_urls.each_slice(10) do |urls|
            if urls.size == 1
              last_message = reply_to_message_with_image(last_message, urls.first, "")
              next
            end

            media_group = urls.map do |url|
              Tourmaline::InputMediaPhoto.new(
                media: url,
                caption: first_caption,
                parse_mode: Tourmaline::ParseMode::MarkdownV2,
              ).tap { first_caption = nil }
            end

            messages = last_message.reply_with_media_group(media_group)
            last_message = messages.last
          rescue ex
            ::Log.for(self.class).warn { "got #{ex} (#{ex.class}) while trying to send one of these urls: #{urls.inspect}, sending the image urls" }
            urls_markdown = urls.map { |url| "- #{url}" }.join("\n")
            last_message.reply("#{markdown_escape urls_markdown}\n\n" + caption, parse_mode: Tourmaline::ParseMode::MarkdownV2)
          end

          last_message
        end
      end
    end
  end
end
