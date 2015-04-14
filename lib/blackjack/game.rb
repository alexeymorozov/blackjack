module Blackjack
  class Game
    def initialize(printer)
      @printer = printer
    end

    def start_from_saving(deck, player_hand, dealer_hand)
      @deck = Deck.create_from_string(deck)
      @player_hand = Hand.create_player_hand_from_string(player_hand)
      @dealer_hand = Hand.create_dealer_hand_from_string(dealer_hand)
    end

    def start(deck)
      welcome
      initial_deal(deck)
      evaluate_turn
    end

    def hit
      @player_hand << @deck.pop.face_up
      evaluate_turn
    end

    private

    def welcome
      @printer.puts('Welcome to Blackjack!')
    end

    def player_has_enough
      @player_hand.score == 21
    end

    def initial_deal(deck)
      @deck = deck.split.reverse.map { |code| Card.new(code) }
      @player_hand = Hand.new
      @dealer_hand = Hand.new
      hands = [@player_hand, @dealer_hand]

      2.times do |i|
        hands.each do |hand|
          card = @deck.pop
          card.face_up if hand == @player_hand || i == 0
          hand << card
        end
      end
    end

    def evaluate_turn
      if player_has_enough
        stand
      else
        show_hands
        prompt_for_action
      end
    end

    def stand
      resolve_dealer_hand
      show_hands
      show_result
    end

    def resolve_dealer_hand
      @dealer_hand.face_up
      while @dealer_hand.score < 17
        @dealer_hand << @deck.pop.face_up
      end
    end

    def show_hands
      @printer.puts("Dealer's hand: #{@dealer_hand}. Score: #{@dealer_hand.score}.")
      @printer.puts("Your hand: #{@player_hand}. Score: #{@player_hand.score}.")
    end

    def show_result
      if @dealer_hand.score < 21
        send_win
      else
        send_push
      end
    end

    def send_win
      @printer.puts("You win!")
    end

    def send_push
      @printer.puts("You push!")
    end

    def prompt_for_action
      @printer.puts("Enter action:")
    end
  end
end
