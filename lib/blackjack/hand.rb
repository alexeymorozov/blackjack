module Blackjack
  class Hand
    include Comparable

    def self.create_player_hand_from_string(card_codes)
      cards = card_codes.split.map { |code| Card.new(code).face_up }
      self.new(cards)
    end

    def self.create_dealer_hand_from_string(card_codes)
      cards = card_codes.split.map { |code| Card.new(code) }
      cards[0].face_up
      self.new(cards)
    end

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

    def full?
      score == 21
    end

    def <=>(other)
      if blackjack? && other.blackjack?
        0
      elsif blackjack?
        1
      elsif other.blackjack?
        -1
      else
        score <=> other.score
      end
    end

    def blackjack?
      score == 21 && @cards.size == 2
    end

    def score
      face_up_cards = @cards.find_all { |card| card.face_up? }

      no_ace_bonus_score = face_up_cards
        .reduce(0) do |score, card|
          value =
            case card.rank
            when 'A' then 1
            when 'K', 'Q', 'J', 'T' then 10
            when '2'..'9' then card.rank.to_i
            else raise Exception.new("Unknown card rank '#{card.rank}'.")
            end

          score + value
        end

      full_score = face_up_cards
        .find_all { |card| card.rank == 'A' }
        .reduce(no_ace_bonus_score) do |score, card|
          bonus = 10
          score + bonus > 21 ? score : score + bonus
        end

      full_score
    end

    def to_s
      @cards.join(' ')
    end
  end
end
