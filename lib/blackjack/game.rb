module Blackjack
  class Game
    INITIAL_PLAYER_MONEY = 1000
    MINIMUM_BET = 1

    attr_writer :player_money

    def initialize(printer)
      @printer = printer
      @player_money = INITIAL_PLAYER_MONEY
    end

    def start_from_saving(deck, player_hand, dealer_hand, bet = MINIMUM_BET, player_money = INITIAL_PLAYER_MONEY - MINIMUM_BET)
      @deck = Deck.create_from_string(deck)
      @player_hand = Hand.create_player_hand_from_string(player_hand)
      @dealer_hand = DealerHand.create_dealer_hand_from_string(dealer_hand)
      @bet = bet
      @player_money = player_money
      @round_started = true
    end

    def start
      welcome
      show_money
      prompt_for_bet
    end

    def start_round(bet, deck = nil)
      return send_game_over if @game_over

      return send_round_already_started if @round_started
      @round_started = true

      begin
        bet(bet)
      rescue NoMoneyLeft
        return send_no_money_left
      end

      begin
        initial_deal(deck)
      rescue EmptyDeck
        return send_no_cards_left
      end

      evaluate_turn
    end

    def hit
      return send_game_over if @game_over
      return send_round_not_started_yet unless @round_started
      @player_hand << @deck.pop.face_up
      evaluate_turn
    end

    def stand
      return send_game_over if @game_over

      return send_round_not_started_yet unless @round_started
      resolve_dealer_hand
      finish_round
    end

    private

    def welcome
      @printer.puts('Welcome to Blackjack!')
    end

    def prompt_for_bet
      @printer.puts('Enter bet:')
    end

    def send_round_already_started
      @printer.puts("The round has already been started.")
    end

    def send_round_not_started_yet
      @printer.puts("The round hasn't been started yet.")
    end

    def send_game_over
      @printer.puts("The game is over.")
    end

    def send_no_cards_left
      @game_over = true
      @printer.puts("No cards left in the deck. Game over!")
    end

    def send_no_money_left
      @game_over = true
      @printer.puts("No money left. Game over!")
    end

    def bet(bet)
      raise NoMoneyLeft if @player_money < MINIMUM_BET
      integer_bet = bet.to_i
      if integer_bet < MINIMUM_BET
        @bet = MINIMUM_BET
      elsif integer_bet > @player_money
        @bet = @player_money
      else
        @bet = integer_bet
      end

      @player_money -= @bet

      show_bet
    end

    def initial_deal(deck)
      @deck = deck ? Deck.create_from_string(deck) : @deck
      @player_hand = Hand.new
      @dealer_hand = DealerHand.new
      hands = [@player_hand, @dealer_hand]

      2.times do |i|
        hands.each do |hand|
          card = @deck.pop
          card.face_up if hand.equal?(@player_hand) || i == 0
          hand << card
        end
      end
    end

    def evaluate_turn
      if @player_hand.busted?
        finish_round
      elsif @player_hand.full?
        stand
      else
        continue_round
      end
    end

    def resolve_dealer_hand
      @dealer_hand.face_up
      while !@dealer_hand.full? && !@player_hand.has_blackjack?
        @dealer_hand << @deck.pop.face_up
      end
    end

    def finish_round
      show_hands
      show_result
      @round_started = false
    end

    def continue_round
      show_hands
      prompt_for_action
    end

    def show_result
      if @player_hand.busted?
        send_loss
      elsif @dealer_hand.busted?
        send_win
      elsif @player_hand > @dealer_hand
        send_win
      elsif @player_hand < @dealer_hand
        send_loss
      else
        send_push
      end
    end

    def show_bet
      @printer.puts("Your money: #{@player_money}. Bet: #{@bet}.")
    end

    def show_hands
      @printer.puts("Dealer's hand: #{@dealer_hand}. Score: #{@dealer_hand.score}.")
      @printer.puts("Your hand: #{@player_hand}. Score: #{@player_hand.score}.")
    end

    def show_money
      @printer.puts("Your money: #{@player_money}.")
    end

    def send_win
      @printer.puts("You win!")
      @player_money += (@bet * (@player_hand.has_blackjack? ? 2.5 : 2)).to_i
      @bet = 0
      show_money
    end

    def send_loss
      @printer.puts("You loose!")
      @bet = 0
      show_money
    end

    def send_push
      @printer.puts("You push!")
      @player_money += @bet
      @bet = 0
      show_money
    end

    def prompt_for_action
      @printer.puts("Enter action:")
    end
  end
end
