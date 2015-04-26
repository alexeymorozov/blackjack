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
        @game.player_hands.current.finish!
        resolve_or_next_hand
      end

      def hit
        @game.player_hands.current << @game.pop_card.face_up
        resolve_or_next_hand
      end

      private

      def resolve_or_next_hand
        if @game.player_hands.all_finished?
          @game.set_resolving
          @game.resolve
        else
          @game.player_hands.next_not_finished
        end
      end
    end
  end
end
