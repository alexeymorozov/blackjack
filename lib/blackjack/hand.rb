module Blackjack
  class Hand
    include Comparable

    MAXIMUM_PLAYING_SCORE = 21
    COUNT_OF_CARDS_IN_BLACKJACK_HAND = 2

    attr_accessor :bet

    def self.create_player_hand_from_string(card_codes)
      cards = card_codes.split.map { |code| Card.new(code).face_up }
      self.new(cards)
    end

    def self.create_dealer_hand_from_string(card_codes)
      cards = card_codes.split.map { |code| Card.new(code) }
      cards[0].face_up
      self.new(cards)
    end

    def initialize(cards = [], bet = 1)
      @cards = []
      cards.each do |card|
        receive(card)
      end

      @bet = bet
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

    def busted?
      score > MAXIMUM_PLAYING_SCORE
    end

    def full?
      score == MAXIMUM_PLAYING_SCORE
    end

    def <=>(other)
      if has_blackjack? && other.has_blackjack?
        0
      elsif has_blackjack?
        1
      elsif other.has_blackjack?
        -1
      else
        score <=> other.score
      end
    end

    def has_blackjack?
      score == MAXIMUM_PLAYING_SCORE && @cards.size == COUNT_OF_CARDS_IN_BLACKJACK_HAND
    end

    def score
      aces.reduce(no_ace_bonus_score) do |score, card|
        score + Card::ACE_BONUS > MAXIMUM_PLAYING_SCORE ? score : score + Card::ACE_BONUS
      end
    end

    def no_ace_bonus_score
      upcards.reduce(0) { |score, card| score + card.value }
    end

    def aces
      upcards.find_all(&:ace?)
    end

    def upcards
      @cards.find_all { |card| card.face_up? }
    end

    def to_s
      @cards.join(' ')
    end
  end
end
