module Blackjack
  module State
    class IdlingState
      def initialize(game)
        @game = game
      end

      def start_round
        @game.player_hands = [Hand.new]
        @game.current_hand = @game.player_hands.first
        @game.dealer_hand = DealerHand.new
        @game.state = Game::STATE_BETTING
      end

      def bet(amount)
        raise InvalidAction
      end

      def stand
        raise InvalidAction
      end

      def hit
        raise InvalidAction
      end
    end
  end
end
