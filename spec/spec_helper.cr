require "spec"

# set up fake ENV variables for testing
{
  "TELEGRAM_API_KEY"      => "fake_telegram_key",
  "FUR_AFFINITY_COOKIE_A" => "fake_fa_cookie_a",
  "FUR_AFFINITY_COOKIE_B" => "fake_fa_cookie_b",
  "IMGUR_CLIENT_ID"       => "fake_imgur_client_id",
}.each do |key, value|
  ENV[key] = value
end

require "webmock"
require "./support/fixtures"

require "../src/cyber_jyrki"
