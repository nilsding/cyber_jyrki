require "./cyber_jyrki"

require "dotenv"

Dotenv.load

CyberJyrki::Application.start(
  telegram_token: ENV.fetch("TELEGRAM_API_KEY"),
)
