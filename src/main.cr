require "dotenv"

# load dotenv before anything else
Dotenv.load

require "./cyber_jyrki"

CyberJyrki::Application.start(
  telegram_token: ENV.fetch("TELEGRAM_API_KEY"),
)
