module Blackjack
  class HandList
    def initialize(hands)
      @hands = hands
      @enum = hands.to_enum
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
      @enum.rewind
      @current = nil
    end

    def next
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
