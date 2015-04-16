module Blackjack
  class Deck
    def self.create_from_string(card_codes)
      cards = card_codes.split.reverse.map { |code| Card.new(code) }
      self.new(cards)
    end

    def self.create_standard_deck
      suits = %w(♠ ♥ ♦ ♣)
      ranks = %w(A K Q J T 9 8 7 6 5 4 3 2)
      cards = ranks.product(suits).map { |rank, suit| Card.new(rank + suit) }
      self.new(cards)
    end

    def initialize(cards)
      @cards = cards
    end

    def shuffle!
      @cards.shuffle!
    end

    def pop
      card = @cards.pop
      raise EmptyDeck.new if card.nil?
      card
    end

    def empty?
      @cards.empty?
    end
  end
end
