require "./bot"

module CyberJyrki
  class Application
    def self.start(**args)
      self.new(**args).run
    end

    property telegram_token : String

    def initialize(@telegram_token : String)
    end

    def run
      puts "CyberJyrki #{VERSION} starting up..."

      bot = Bot.new(bot_token: telegram_token)
      bot.poll
    end
  end
end
