module Blackjack
  class Card
    ACE_BONUS = 10

    attr_reader :rank, :suit

    def initialize(code)
      @rank = code[0]
      @suit = code[1]
      @face_up = false
    end

    def face_down?
      !face_up?
    end

    def face_up?
      @face_up
    end

    def face_up
      @face_up = true
      self
    end

    def value
      case rank
      when 'A' then 1
      when 'K', 'Q', 'J', 'T' then 10
      when '2'..'9' then rank.to_i
      else raise Exception.new("Unknown card rank '#{rank}'.")
      end
    end

    def ace?
      rank == 'A'
    end

    def to_s
      face_up? ? @rank + @suit : '?'
    end
  end
end
