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
        try_resolve
      end

      def hit
        @game.player_hands.current << @game.pop_card.face_up
        try_resolve
      end

      def try_resolve
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
