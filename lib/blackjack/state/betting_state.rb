module Blackjack
  module State
    class BettingState < AbstractState
      def initialize(game)
        @game = game
      end

      def bet(amount)
        bet = prepare_bet(amount)
        @game.player_money -= bet
        @game.turn.hand.bet = bet

        if @game.player_hands.all_have_bets?
          @game.set_dealing
          @game.deal
        else
          @game.turn.next
        end
      end

      def stand
        raise BettingNotCompleted
      end

      def hit
        raise BettingNotCompleted
      end

      private

      def prepare_bet(bet_candidate)
        integer_bet = bet_candidate.to_i
        if integer_bet < Game::MINIMUM_BET
          Game::MINIMUM_BET
        elsif integer_bet > @game.player_money
          @game.player_money
        else
          integer_bet
        end
      end
    end
  end
end
