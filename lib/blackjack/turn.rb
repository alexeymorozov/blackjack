module Blackjack
  class Turn
    def initialize(hands)
      @hands = hands
      @enum = hands.to_enum
      rewind_to_first
    end

    def hand
      @hand
    end

    def rewind_to_first
      @enum.rewind
      self.next
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
      @hand = @enum.next
    rescue StopIteration
      @enum.rewind
      @hand = @enum.next
    end
  end
end
