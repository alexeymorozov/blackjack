module Blackjack
  class BlackjackError < StandardError
  end

  class InvalidAction < BlackjackError
  end

  class BettingAlreadyDone < InvalidAction
  end

  class BettingNotCompleted < InvalidAction
  end

  class EmptyDeck < BlackjackError
  end

  class NoMoneyLeft < BlackjackError
  end

  class GameOver < BlackjackError
  end

  class GameNotFound < BlackjackError
  end
end
