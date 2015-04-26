module Blackjack
  class HandList
    def initialize(hands)
      @hands = hands
      @enum = hands.to_enum
    end

    def all_finished?
      @hands.all? { |hand| hand.finished? }
    end

    def all_busted?
      @hands.all? { |hand| hand.busted? }
    end

    def all_have_blackjacks?
      @hands.all? { |hand| hand.has_blackjack? }
    end

    def all_have_bets?
      @hands.all? { |hand| hand.bet }
    end

    def dealt?
      @hands.any? { |hand| hand.dealt? }
    end

    def first
      @hands.first
    end

    def each(&block)
      @hands.each(&block)
    end

    def current
      @current
    end

    def rewind
      @enum.rewind
      @current = nil
    end

    def next_not_finished
      raise "All finished" if all_finished?

      candidate = nil

      loop do
        begin
          candidate = @enum.next
          break unless candidate.finished?
        rescue StopIteration
          @enum.rewind
        end
      end

      @current = candidate
    end
  end
end
