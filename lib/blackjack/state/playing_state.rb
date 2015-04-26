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
        try_resolve
        @game.evaluate_turn
      end

      def hit
        @game.current_hand << @game.pop_card.face_up
        try_resolve
        @game.evaluate_turn
      end

      def try_resolve
        if @game.player_hands.all_finished?
          @game.set_resolving
          @game.resolve
        end
      end
    end
  end
end
