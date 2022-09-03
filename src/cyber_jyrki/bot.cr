require "log"
require "tourmaline"
require "../ext/tourmaline"

require "./use_case/actions/commands/start"
require "./use_case/actions/hears/fur_affinity"
require "./use_case/actions/hears/reddit"

module CyberJyrki
  class Bot < Tourmaline::Client
    Log = ::Log.for(self)

    @[Command("start", private_only: true)]
    def start_command(ctx)
      UseCase::Actions::Commands::Start.call(ctx)
    end

    @[Hears(%r(furaffinity\.net/view/(?<post_id>\d+)))]
    def furaffinity(ctx)
      UseCase::Actions::Hears::FurAffinity.call(ctx)
    end

    @[Hears(%r{(?:reddit\.com/r/[^/]+/comments|(?<![iv]\.)redd\.it)/(?<post_id>[^/\s$]+)})]
    def reddit(ctx)
      UseCase::Actions::Hears::Reddit.call(ctx)
    end
  end
end
