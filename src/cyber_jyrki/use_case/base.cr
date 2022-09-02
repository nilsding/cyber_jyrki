require "log"

module CyberJyrki
  module UseCase
    abstract class Base
      def self.call(*args)
        new(*args).call
      end
    end
  end
end
