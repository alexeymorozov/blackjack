module Blackjack
  module State
    class GameOverState
      def initialize(game)
        @game = game
      end

      def start_round
        raise GameOver
      end

      def bet(amount)
        raise GameOver
      end

      def stand
        raise InvalidAction
      end

      def hit
        raise InvalidAction
      end
    end
  end
end
