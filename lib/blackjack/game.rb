module Blackjack
  class Game
    INITIAL_PLAYER_MONEY = 1000
    MINIMUM_BET = 1

    STATE_IDLING = :idling
    STATE_BETTING = :betting
    STATE_PLAYING = :playing
    STATE_GAME_OVER = :game_over

    @@storage = Hash.new

    attr_reader :current_hand, :player_hands, :dealer_hand, :player_money
    attr_accessor :state

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
      @state = has_prerequisites? ? STATE_IDLING : STATE_GAME_OVER
      @commands = [
        Command::DealCommand.new(self),
        Command::ResolveCommand.new(self),
        Command::TurnCommand.new
      ]
    end

    def start_round
      raise GameOver if game_over?
      raise InvalidAction unless idling?
      @player_hands = [Hand.new]
      @current_hand = @player_hands.first
      @dealer_hand = DealerHand.new
      @state = STATE_BETTING
    end

    def bet(amount)
      raise GameOver if game_over?
      raise BettingAlreadyDone if @current_hand && @current_hand.bet
      raise InvalidAction unless can_bet?
      raise InvalidAction unless @state == STATE_BETTING
      bet = prepare_bet(amount)
      @player_money -= bet
      @current_hand.bet = bet
      evaluate_turn
    end

    def stand
      raise BettingNotCompleted unless all_hands_have_bets?
      raise InvalidAction unless can_stand?
      raise InvalidAction unless @state == STATE_PLAYING
      @current_hand.finish!
      evaluate_turn
    end

    def hit
      raise BettingNotCompleted unless all_hands_have_bets?
      raise InvalidAction unless can_stand?
      raise InvalidAction unless @state == STATE_PLAYING
      @current_hand << pop_card.face_up
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

    def idling?
      @state == STATE_IDLING
    end

    def game_over?
      @state == STATE_GAME_OVER
    end

    def has_prerequisites?
      has_money? && has_cards?
    end

    def has_money?
      @player_money >= MINIMUM_BET
    end

    def has_cards?
      !@deck.empty?
    end

    def pop_card
      begin
        @deck.pop
      rescue EmptyDeck => ex
        @state = STATE_GAME_OVER
        raise ex
      end
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
