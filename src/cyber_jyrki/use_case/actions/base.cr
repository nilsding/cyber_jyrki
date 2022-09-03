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
      end
    end
  end
end
