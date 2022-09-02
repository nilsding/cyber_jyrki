require "log"
require "tourmaline"
require "../ext/tourmaline"

require "./use_case/actions/start"

module CyberJyrki
  class Bot < Tourmaline::Client
    Log = ::Log.for(self)

    @[Command("start", private_only: true)]
    def start_command(ctx)
      UseCase::Actions::Start.call(ctx)
    end
  end
end
