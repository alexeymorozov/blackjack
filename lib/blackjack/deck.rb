module Blackjack
  class Deck
    def self.create_from_string(card_codes)
      card_codes.split.reverse.map { |code| Card.new(code) }
    end

    def self.create_standard_deck
      suits = %w(♠ ♥ ♦ ♣)
      ranks = %w(A K Q J T 9 8 7 6 5 4 3 2)
      ranks.product(suits).map { |rank, suit| Card.new(rank + suit) }
    end
  end
end
