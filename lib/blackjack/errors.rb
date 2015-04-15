module Blackjack
  class BlackjackError < StandardError
  end

  class EmptyDeck < BlackjackError
  end

  class NoMoneyLeft < BlackjackError
  end
end
