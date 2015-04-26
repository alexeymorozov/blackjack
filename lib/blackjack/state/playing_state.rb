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
        @game.turn.hand.finish!
        resolve_or_next_hand
      end

      def hit
        @game.turn.hand << @game.pop_card.face_up
        resolve_or_next_hand
      end

      private

      def resolve_or_next_hand
        if @game.player_hands.all_finished?
          @game.set_resolving
          @game.resolve
        else
          @game.turn.next_not_finished
        end
      end
    end
  end
end
