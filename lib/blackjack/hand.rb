module Blackjack
  class Hand
    def initialize(cards = [])
      @cards = []
      cards.each do |card|
        receive(card)
      end
    end

    def receive(card)
      card = Card.new(card) unless card.is_a? Card
      @cards << card
    end
    alias_method :<<, :receive

    def face_up
      @cards.each do |card|
        card.face_up
      end
    end

    def score
      @cards.reduce(0) do |score, card|
        if card.face_down?
          value = 0
        else
          value = case card.rank
                  when 'A' then 11
                  when 'K', 'Q', 'J', 'T' then 10
                  when '2'..'9' then card.rank.to_i
                  else raise Exception.new("Unknown card rank '#{card.rank}'.")
                  end
        end

        score + value
      end
    end

    def to_s
      @cards.join(' ')
    end
  end
end
