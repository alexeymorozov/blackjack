module Blackjack
  module State
    class PlayingState < AbstractState
      def initialize(game)
        @game = game
      end

      def bet(amount)
        raise BettingAlreadyDone
      end

      def stand
        @game.current_hand.finish!
        @game.evaluate_turn
      end

      def hit
        @game.current_hand << @game.pop_card.face_up
        @game.evaluate_turn
      end
    end
  end
end
