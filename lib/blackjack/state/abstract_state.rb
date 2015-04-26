module Blackjack
  module State
    class AbstractState
      def method_missing(*args, &block)
        raise InvalidAction
      end
    end
  end
end
