module Blackjack
  module Command
    class DealCommand
      def initialize(game)
        @game = game
      end

      def can_be_run?(player_hands)
        all_hands_have_bets?(player_hands) && !dealt?(player_hands)
      end

      def run(player_money, deck, player_hands, dealer_hand, current_hand)
        hands = player_hands + [dealer_hand]
        2.times do |i|
          hands.each do |hand|
            card = @game.pop_card
            card.face_up unless hand.equal?(dealer_hand) && i == 1
            hand << card
          end
        end

        @game.state = Game::STATE_PLAYING

        [nil, player_money]
      end

      private

      def all_hands_have_bets?(player_hands)
        player_hands.all? { |hand| hand.bet }
      end

      def dealt?(player_hands)
        player_hands.any? { |hand| hand.dealt? }
      end
    end
  end
end
