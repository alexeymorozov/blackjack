module Blackjack
  module Command
    class TurnCommand
      def can_be_run?(player_hands)
        true
      end

      def run(player_money, deck, player_hands, dealer_hand, current_hand)
        if all_hands_are_finished?(player_hands)
          return [nil, player_money]
        end

        loop do
          if current_hand.nil?
            next_index = 0
          else
            current_index = player_hands.find_index(current_hand)
            next_index = current_index + 1
            max_index = player_hands.size - 1
            if next_index > max_index
              next_index = 0
            end
          end

          current_hand = player_hands[next_index]
          break if !current_hand.finished?
        end

        [current_hand, player_money]
      end

      private

      def all_hands_are_finished?(player_hands)
        player_hands.all? { |hand| hand.finished? }
      end
    end
  end
end
