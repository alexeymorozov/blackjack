module Blackjack
  module State
    class DealingState < AbstractState
      def initialize(game)
        @game = game
      end

      def deal
        hands = @game.player_hands + [@game.dealer_hand]
        2.times do |i|
          hands.each do |hand|
            card = @game.pop_card
            card.face_up unless hand.equal?(@game.dealer_hand) && i == 1
            hand << card
          end
        end

        @game.player_hands.current = nil

        @game.set_playing
        @game.evaluate_turn
      end
    end
  end
end
