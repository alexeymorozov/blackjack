module Blackjack
  module State
    class IdlingState < AbstractState
      def initialize(game)
        @game = game
      end

      def start_round
        @game.player_hands = HandList.new([Hand.new])
        @game.dealer_hand = DealerHand.new
        @game.turn = Turn.new(@game.player_hands)
        @game.set_betting
      end
    end
  end
end
