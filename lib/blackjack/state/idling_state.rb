module Blackjack
  module State
    class IdlingState < AbstractState
      def initialize(game)
        @game = game
      end

      def start_round
        @game.player_hands = HandList.new([Hand.new])
        @game.player_hands.next_not_finished
        @game.dealer_hand = DealerHand.new
        @game.set_betting
      end
    end
  end
end
