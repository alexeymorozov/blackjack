module Blackjack
  class Game
    def initialize(printer)
      @printer = printer
    end

    def start(deck)
      welcome
      initial_deal(deck)
      result = @player_hand.score == 21 ? stand : :continue
      show_hands
      show_result(result)
    end

    def welcome
      @printer.puts('Welcome to Blackjack!')
    end

    def initial_deal(deck)
      @deck = deck.split.reverse
      @player_hand = Hand.new
      @dealer_hand = Hand.new

      2.times do |i|
        @player_hand << Card.new(@deck.pop).face_up

        card = Card.new(@deck.pop)
        card.face_up if i == 0
        @dealer_hand << card
      end
    end

    def show_hands
      @printer.puts("Dealer's hand: #{@dealer_hand}. Score: #{@dealer_hand.score}.")
      @printer.puts("Your hand: #{@player_hand}. Score: #{@player_hand.score}.")
    end

    def stand
      @dealer_hand.face_up
      if @dealer_hand.score < 21
        :win
      else
        :push
      end
    end

    def show_result(result)
      message = case result
                when :win then "You win!"
                when :push then "You push!"
                when :continue then "Enter action:"
                end
      @printer.puts(message)
    end
  end
end
