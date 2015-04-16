module Blackjack
  class Game
    INITIAL_PLAYER_MONEY = 1000
    MINIMUM_BET = 1

    attr_writer :player_money
    attr_reader :message_sender

    def initialize(message_sender)
      @message_sender = message_sender
      @player_money = INITIAL_PLAYER_MONEY
      @deck = Deck.create_standard_deck.shuffle!

      @commands = [
        Command::DealCommand.new,
        Command::ResolveCommand.new(message_sender),
        Command::TurnCommand.new
      ]

      new_round
    end

    def new_round
      initialize_hands
      start
    end

    def initialize_hands
      @player_hands = [Hand.new]
      @current_hand = @player_hands.first
      @dealer_hand = DealerHand.new
    end

    def start
      @message_sender.welcome
      wait_for_bet
    end

    def start_from_saving(deck, player_hand, dealer_hand, bet = MINIMUM_BET, player_money = INITIAL_PLAYER_MONEY - MINIMUM_BET)
      @player_money = player_money
      @deck = Deck.create_from_string(deck)

      hand = Hand.create_player_hand_from_string(player_hand)
      hand.bet = bet
      @player_hands = [hand]
      @current_hand = @player_hands.first

      @dealer_hand = DealerHand.create_dealer_hand_from_string(dealer_hand)
    end

    def deck_from_string(deck)
      @deck = deck ? Deck.create_from_string(deck) : @deck
    end

    def bet(amount)
      raise GameOver if game_over?
      raise BettingAlreadyDone if @current_hand.bet
      do_bet(amount)
      rest
    end

    def stand
      raise BettingNotCompleted unless all_hands_have_bets
      @current_hand.finish
      rest
    end

    def hit
      raise BettingNotCompleted unless all_hands_have_bets
      @current_hand << @deck.pop.face_up
      @message_sender.send_loss if @current_hand.busted?
      @message_sender.show_hands(@dealer_hand, @current_hand)
      rest
    end

    private

    def rest
      @commands.each do |command|
        if command.can_be_run?(@player_hands)
          @current_hand, @player_money = command.run(@player_money, @deck, @player_hands, @dealer_hand, @current_hand)
        end
      end

      if @current_hand
        wait_for_action
      end
    end

    def game_over?
      @player_money < MINIMUM_BET || @deck.empty?
    end

    def do_bet(amount)
      bet = prepare_bet(amount)
      @player_money -= bet
      @current_hand.bet = bet
      @message_sender.show_bet(@player_money, @current_hand)
    end

    def prepare_bet(bet_candidate)
      integer_bet = bet_candidate.to_i
      if integer_bet < MINIMUM_BET
        MINIMUM_BET
      elsif integer_bet > @player_money
        @player_money
      else
        integer_bet
      end
    end

    def all_hands_have_bets
      @player_hands.all? { |hand| hand.bet }
    end

    def wait_for_bet
      @message_sender.show_money(@player_money)
      @message_sender.prompt_for_bet
    end

    def wait_for_action
      @message_sender.show_hands(@dealer_hand, @current_hand)
      @message_sender.prompt_for_action
    end
  end
end
