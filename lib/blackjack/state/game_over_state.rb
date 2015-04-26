module Blackjack
  module State
    class GameOverState < AbstractState
      def initialize(game)
        @game = game
      end

      def start_round
        raise GameOver
      end

      def bet(amount)
        raise GameOver
      end
    end
  end
end
