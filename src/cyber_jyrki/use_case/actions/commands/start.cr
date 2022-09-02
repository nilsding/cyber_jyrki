require "./base"

module CyberJyrki
  module UseCase
    module Actions
      module Commands
        class Start < Base
          Log = ::Log.for(self)

          START_TEXT = <<-TEXT
            Dies ist der persönliche Rechenknecht von @nilsding.
          TEXT

          def call
            Log.info do
              user = "a mysterious user????"
              if u = context.message.from
                user = "#{u.id} (#{u.username.inspect})"
              end
              "responding to #{user} with the info text"
            end
            context.message.respond(START_TEXT)
          end
        end
      end
    end
  end
end
