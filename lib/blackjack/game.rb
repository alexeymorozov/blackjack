module Blackjack
  class Game
    INITIAL_PLAYER_MONEY = 1000
    MINIMUM_BET = 1

    attr_reader :current_hand, :player_hands, :dealer_hand, :player_money

    def initialize(deck = nil, player_money = nil)
      @deck = deck || Deck.create_standard_deck.shuffle!
      @player_money = player_money || INITIAL_PLAYER_MONEY
      @commands = [
        Command::DealCommand.new,
        Command::ResolveCommand.new,
        Command::TurnCommand.new
      ]
    end

    def start_round
      @player_hands = [Hand.new]
      @current_hand = @player_hands.first
      @dealer_hand = DealerHand.new
    end

    def bet(amount)
      raise GameOver if game_over?
      raise BettingAlreadyDone if @current_hand.bet
      bet = prepare_bet(amount)
      @player_money -= bet
      @current_hand.bet = bet
      evaluate_turn
    end

    def stand
      raise BettingNotCompleted unless all_hands_have_bets
      @current_hand.finish!
      evaluate_turn
    end

    def hit
      raise BettingNotCompleted unless all_hands_have_bets
      @current_hand << @deck.pop.face_up
      evaluate_turn
    end

    def game_over?
      @player_money < MINIMUM_BET || @deck.empty?
    end

    private

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

    def evaluate_turn
      @commands.each do |command|
        if command.can_be_run?(@player_hands)
          @current_hand, @player_money = command.run(@player_money, @deck, @player_hands, @dealer_hand, @current_hand)
        end
      end
    end

    def all_hands_have_bets
      @player_hands.all? { |hand| hand.bet }
    end
  end
end
