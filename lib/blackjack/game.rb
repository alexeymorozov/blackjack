module Blackjack
  class Game
    INITIAL_PLAYER_MONEY = 1000
    MINIMUM_BET = 1

    STATE_IDLING = :idling
    STATE_BETTING = :betting
    STATE_PLAYING = :playing
    STATE_GAME_OVER = :game_over

    @@storage = Hash.new

    attr_accessor :player_money, :deck, :player_hands, :current_hand, :dealer_hand, :state

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
      if idling?
        State::IdlingState.new(self).start_round
      elsif betting?
        State::BettingState.new(self).start_round 
      elsif playing?
        State::PlayingState.new(self).start_round
      elsif game_over?
        State::GameOverState.new(self).start_round
      else
        raise
      end
    end

    def bet(amount)
      if idling?
        State::IdlingState.new(self).bet(amount)
      elsif betting?
        State::BettingState.new(self).bet(amount)
      elsif playing?
        State::PlayingState.new(self).bet(amount)
      elsif game_over?
        State::GameOverState.new(self).bet(amount)
      else
        raise
      end
    end

    def stand
      if idling?
        State::IdlingState.new(self).stand
      elsif betting?
        State::BettingState.new(self).stand
      elsif playing?
        State::PlayingState.new(self).stand
      elsif game_over?
        State::GameOverState.new(self).stand
      else
        raise
      end
    end

    def hit
      if idling?
        State::IdlingState.new(self).hit
      elsif betting?
        State::BettingState.new(self).hit
      elsif playing?
        State::PlayingState.new(self).hit
      elsif game_over?
        State::GameOverState.new(self).hit
      else
        raise
      end
    end

    def dealt?
      @player_hands.any? { |hand| hand.dealt? }
    end

    def idling?
      @state == STATE_IDLING
    end

    def betting?
      @state == STATE_BETTING
    end

    def playing?
      @state == STATE_PLAYING
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

    def evaluate_turn
      @commands.each do |command|
        if command.can_be_run?(@player_hands)
          @current_hand, @player_money = command.run(@player_money, @deck, @player_hands, @dealer_hand, @current_hand)
        end
      end
    end
  end
end
