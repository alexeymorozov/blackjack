module Blackjack
  module State
    class IdlingState < AbstractState
      def initialize(game)
        @game = game
      end

      def start_round
        @game.player_hands = [Hand.new]
        @game.current_hand = @game.player_hands.first
        @game.dealer_hand = DealerHand.new
        @game.set_betting
      end
    end
  end
end
