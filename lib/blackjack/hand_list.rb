module Blackjack
  class HandList < Array
    attr_accessor :current

    def all_finished?
      all? { |hand| hand.finished? }
    end

    def all_busted?
      all? { |hand| hand.busted? }
    end

    def all_have_blackjacks?
      all? { |hand| hand.has_blackjack? }
    end

    def all_have_bets?
      all? { |hand| hand.bet }
    end

    def dealt?
      any? { |hand| hand.dealt? }
    end

    def next
      candidate_hand = current

      loop do
        if candidate_hand.nil?
          next_index = 0
        else
          current_index = find_index(candidate_hand)
          max_index = size - 1
          next_index = current_index == max_index ? 0 : current_index + 1
        end

        candidate_hand = slice(next_index)
        break if !candidate_hand.finished?
      end

      @current = candidate_hand
    end
  end
end
