module Tourmaline
  module Handlers
    class CommandHandler
      # sourced from: https://github.com/protoncr/tourmaline/blame/430a68570ee4b8486ac435171cf641a839f0eb37/src/tourmaline/handlers/command_handler.cr
      def call(update : Update)
        if (message = update.message || update.channel_post) || (@on_edit && (message = update.edited_message || update.edited_channel_post))
          return if message.outgoing? unless @outgoing
          if ((raw_text = message.raw_text) && (text = message.text)) ||
             (raw_text = message.raw_caption && (text = message.caption))
            # BEGIN HACK(nilsding): for some reason it was:
            # return if private_only && message.chat.private?
            return if private_only && !message.chat.private?
            # END HACK
            return if group_only && message.chat.private?

            text = text.to_s
            raw_text = raw_text.to_s

            tokens = text.split(/\s+/)
            tokens = tokens.size > 1 ? text.split(/\s+/, 2) : [tokens[0], ""]

            # BEGIN HACK(nilsding): do NOT use raw_text here!
            # for some reason some helper method seriously mangles the text on my machine:
            #     {raw_text: "⼀栀攀氀瀀\u2000琀攀猀琀\u2000", text: "/help test"}
            #
            # original: raw_tokens = raw_text.split(/\s+/)
            raw_tokens = text.split(/\s+/)
            # END HACK
            return if tokens.empty?

            command = raw_tokens[0]
            text = tokens[1]

            if command.starts_with?('/') && command.includes?("@")
              command, botname = command.split("@", 2)
              return unless botname.downcase == client.bot.username.to_s.downcase
            end

            prefix_re = /^#{@prefixes.map(&->Regex.escape(String)).join('|')}/

            return unless command.match(prefix_re)
            command = command.sub(prefix_re, "")
            return unless @commands.includes?(command)

            context = Context.new(update, update.context, message, command, text, raw_text, !!botname, !!update.edited_message)
            @proc.call(context)
            return true
          end
        end
      end
    end
  end
end
