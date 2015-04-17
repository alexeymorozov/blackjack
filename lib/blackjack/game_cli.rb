module Blackjack
  class GameCLI
    def initialize(game, message_sender)
      @game = game
      @message_sender = message_sender
    end

    def start_round
      @game.start_round
      @message_sender.welcome
      @message_sender.show_money(@game.player_money)
      @message_sender.prompt_for_bet
    end

    def bet(*args)
      begin
        @game.bet(*args)
      rescue NoMoneyLeft
        @message_sender.send_no_money_left
      rescue EmptyDeck
        @message_sender.send_no_cards_left
      rescue BettingAlreadyDone
        @message_sender.send_betting_already_done
      rescue RoundAlreadyStarted
        @message_sender.send_round_already_started
      rescue GameOver
        @message_sender.send_game_over
      end

      if @game.player_hands.first.bet
        @message_sender.show_bet(@game.player_money, @game.player_hands.first)
      end

      show_hands
    end

    def stand(*args)
      begin
        @game.stand(*args)
      rescue EmptyDeck
        @message_sender.send_no_cards_left
      rescue BettingNotCompleted
        @message_sender.send_betting_not_completed
      end

      show_hands
    end

    def hit(*args)
      begin
        @game.hit(*args)
      rescue EmptyDeck
        @message_sender.send_no_cards_left
      rescue BettingNotCompleted
        @message_sender.send_betting_not_completed
      end

      show_hands
    end

    def show_hands
      if @game.player_hands.first.dealt?
        @message_sender.show_hands(@game.dealer_hand, @game.player_hands.first)
      end

      if @game.current_hand.nil?
        @message_sender.show_money(@game.player_money)
        hand = @game.player_hands.first
        if hand.win?
          @message_sender.send_win
        elsif hand.push?
          @message_sender.send_push
        elsif hand.loss?
          @message_sender.send_loss
        end

        if @game.game_over?
          @message_sender.send_game_over
        end
      end

      @message_sender.prompt_for_action
    end

    def method_missing(*args)
      @game.send(*args)
    end
  end
end
