module Blackjack
  class Game
    INITIAL_PLAYER_MONEY = 1000
    MINIMUM_BET = 1

    @@storage = Hash.new

    attr_accessor :player_money, :deck, :player_hands, :dealer_hand, :state

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

      @idling_state = State::IdlingState.new(self)
      @betting_state = State::BettingState.new(self)
      @dealing_state = State::DealingState.new(self)
      @playing_state = State::PlayingState.new(self)
      @game_over_state = State::GameOverState.new(self)

      set_between_rounds_state

      @commands = [
        Command::ResolveCommand.new(self),
        Command::TurnCommand.new
      ]
    end

    def start_round
      @state.start_round
    end

    def bet(amount)
      @state.bet(amount)
    end

    def deal
      @state.deal
    end

    def stand
      @state.stand
    end

    def hit
      @state.hit
    end

    def dealt?
      @player_hands.dealt?
    end

    def idling?
      @state == @idling_state
    end

    def betting?
      @state == @betting_state
    end

    def playing?
      @state == @playing_state
    end

    def game_over?
      @state == @game_over_state
    end

    def set_between_rounds_state
      @state = has_prerequisites? ? @idling_state : @game_over_state
    end

    def set_betting
      @state = @betting_state
    end

    def set_dealing
      @state = @dealing_state
    end

    def set_playing
      @state = @playing_state
    end

    def set_game_over
      @state = @game_over_state
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

    def current_hand
      @player_hands.current
    end

    def current_hand=(hand)
      @player_hands.current = hand
    end

    def pop_card
      begin
        @deck.pop
      rescue EmptyDeck => ex
        set_game_over
        raise ex
      end
    end

    def evaluate_turn
      @commands.each do |command|
        if command.can_be_run?(@player_hands)
          @player_hands.current, @player_money = command.run(@player_money, @deck, @player_hands, @dealer_hand, @player_hands.current)
        end
      end
    end
  end
end
