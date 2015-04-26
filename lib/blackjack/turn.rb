module Blackjack
  class Turn
    def initialize(hands)
      @hands = hands
      rewind_to_first
    end

    def hand
      @hand
    end

    def rewind_to_first
      @hand = @hands.first
    end

    def next_not_finished
      raise "All finished" if @hands.all_finished?

      loop do
        self.next
        break unless hand.finished?
      end

      hand
    end

    def next
      current_index = @hands.find_index(@hand)
      max_index = @hands.size - 1
      next_index = current_index == max_index ? 0 : current_index + 1
      @hand = @hands[next_index]
    end
  end
end
