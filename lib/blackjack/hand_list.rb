module Blackjack
  class HandList
    def initialize(hands)
      @hands = hands
    end

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

    def current
      @current
    end

    def rewind
      @current = nil
    end

    def next
      candidate_hand = current

      loop do
        if candidate_hand.nil?
          next_index = 0
        else
          current_index = @hands.find_index(candidate_hand)
          max_index = @hands.size - 1
          next_index = current_index == max_index ? 0 : current_index + 1
        end

        candidate_hand = @hands.slice(next_index)
        break if !candidate_hand.finished?
      end

      @current = candidate_hand
    end

    def first
      @hands.first
    end

    def each(&block)
      @hands.each(&block)
    end

    def all?(&block)
      @hands.all?(&block)
    end

    def any?(&block)
      @hands.any?(&block)
    end
  end
end
