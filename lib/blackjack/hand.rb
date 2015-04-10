module Blackjack
  class Hand
    def initialize(cards = [])
      @cards = cards
    end

    def receive(card)
      @cards << card
    end
    alias_method :<<, :receive

    def score
      @cards.reduce(0) do |score, card|
        rank = card[0]
        value = case rank
          when 'A' then 11
          when 'Q', 'J' then 10
          else raise Exception.new("Unknown card rank '#{rank}'.")
          end
        score + value
      end
    end

    def to_s
      @cards.join(' ')
    end
  end
end
