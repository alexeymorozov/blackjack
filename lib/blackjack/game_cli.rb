module Blackjack
  class GameCLI
    def initialize(game = Game.new)
      @game = game
      @message_sender = game.message_sender
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
    end

    def stand(*args)
      begin
        @game.stand(*args)
      rescue EmptyDeck
        @message_sender.send_no_cards_left
      rescue BettingNotCompleted
        @message_sender.send_betting_not_completed
      end
    end

    def hit(*args)
      begin
        @game.hit(*args)
      rescue EmptyDeck
        @message_sender.send_no_cards_left
      rescue BettingNotCompleted
        @message_sender.send_betting_not_completed
      end
    end

    def method_missing(*args)
      @game.send(*args)
    end
  end
end
