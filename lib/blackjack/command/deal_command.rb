module Blackjack
  module Command
    class DealCommand
      def can_be_run?(player_hands)
        all_hands_have_bets?(player_hands) && !dealt?(player_hands)
      end

      def run(player_money, deck, player_hands, dealer_hand, current_hand)
        hands = player_hands + [dealer_hand]
        2.times do |i|
          hands.each do |hand|
            card = deck.pop
            card.face_up unless hand.equal?(dealer_hand) && i == 1
            hand << card
          end
        end

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
