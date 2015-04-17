module Blackjack
  class MessageSender
    def initialize(printer)
      @printer = printer
    end

    def welcome
      @printer.puts('Welcome to Blackjack!')
    end

    def prompt_for_bet
      @printer.puts('Enter bet:')
    end

    def prompt_for_action
      @printer.puts("Enter action:")
    end

    def show_money(player_money)
      @printer.puts("Your money: #{player_money}.")
    end

    def show_bet(player_money, current_hand)
      @printer.puts("Your money: #{player_money}. Bet: #{current_hand.bet}.")
    end

    def show_hands(dealer_hand, current_hand)
      @printer.puts("Dealer's hand: #{dealer_hand}. Score: #{dealer_hand.score}.")
      @printer.puts("Your hand: #{current_hand}. Score: #{current_hand.score}.")
    end

    def send_win
      @printer.puts("You win!")
    end

    def send_loss
      @printer.puts("You loose!")
    end

    def send_push
      @printer.puts("You push!")
    end

    def send_game_over
      @printer.puts("The game is over.")
    end

    def send_no_money_left
      @printer.puts("No money left. Game over!")
    end

    def send_no_cards_left
      @printer.puts("No cards left in the deck. Game over!")
    end

    def send_betting_already_done
      @printer.puts("The betting has already been done.")
    end

    def send_betting_not_completed
      @printer.puts("The betting hasn't been completed yet.")
    end
  end
end
