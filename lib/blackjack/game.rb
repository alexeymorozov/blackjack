module Blackjack
  class Game
    def initialize(printer)
      @printer = printer
    end

    def start(deck)
      welcome
      initial_deal(deck)
      show_hands
      stand if @player_hand.score == 21
    end

    def welcome
      @printer.puts('Welcome to Blackjack!')
    end

    def initial_deal(deck)
      @deck = deck.split.reverse
      @player_hand = Hand.new
      @dealer_hand = Hand.new

      2.times do
        @player_hand << @deck.pop
        @dealer_hand << @deck.pop
      end
    end

    def show_hands
      @printer.puts("Dealer's hand: #{@dealer_hand}. Score: #{@dealer_hand.score}.")
      @printer.puts("Your hand: #{@player_hand}. Score: #{@player_hand.score}.")
    end

    def stand
      if @dealer_hand.score < 21
        @printer.puts("You win!")
      else
        @printer.puts("You push!")
      end
    end
  end
end
