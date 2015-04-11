module Blackjack
  class Card
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

    def to_s
      if face_up?
        @rank + @suit
      else
        '?'
      end
    end
  end
end
