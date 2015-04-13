module Blackjack
  class Deck
    def self.create_from_string(card_codes)
      card_codes.split.reverse.map { |code| Card.new(code) }
    end
  end
end
