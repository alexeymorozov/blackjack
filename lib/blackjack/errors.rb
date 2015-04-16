module Blackjack
  class BlackjackError < StandardError
  end

  class BettingAlreadyDone < BlackjackError
  end

  class BettingNotCompleted < BlackjackError
  end

  class EmptyDeck < BlackjackError
  end

  class NoMoneyLeft < BlackjackError
  end

  class GameOver < BlackjackError
  end

  class RoundAlreadyStarted < BlackjackError
  end
end
