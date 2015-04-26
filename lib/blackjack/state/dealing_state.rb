module Blackjack
  module State
    class DealingState < AbstractState
      def initialize(game)
        @game = game
      end

      def deal
        2.times do |i|
          @game.player_hands.each do |hand|
            hand << @game.pop_card.face_up
          end

          card = @game.pop_card
          card.face_up unless i == 1
          @game.dealer_hand << card
        end

        @game.player_hands.rewind

        @game.set_playing
        @game.try_resolve
      end
    end
  end
end
