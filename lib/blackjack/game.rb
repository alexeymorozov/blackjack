module Blackjack
  class Game
    INITIAL_PLAYER_MONEY = 1000
    MINIMUM_BET = 1

    @@storage = Hash.new

    attr_reader :current_hand, :player_hands, :dealer_hand, :player_money

    def self.create
      game = Game.new
      game.start_round
      @@storage[game.object_id] = game
    end

    def self.find(object_id)
      @@storage[object_id] or raise GameNotFound
    end

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
      raise BettingNotCompleted unless all_hands_have_bets?
      @current_hand.finish!
      evaluate_turn
    end

    def hit
      raise BettingNotCompleted unless all_hands_have_bets?
      @current_hand << @deck.pop.face_up
      evaluate_turn
    end

    def can_bet?
      round_started? && @current_hand.bet.nil?
    end

    def can_stand?
      round_started? && dealt?
    end

    def can_hit?
      round_started? && dealt?
    end

    def can_start_round?
      round_over? && !game_over?
    end

    def dealt?
      @player_hands.any? { |hand| hand.dealt? }
    end

    def round_started?
      !round_over? && !game_over?
    end

    def round_over?
      @current_hand.nil?
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

    def all_hands_have_bets?
      @player_hands.all? { |hand| hand.bet }
    end
  end
end
