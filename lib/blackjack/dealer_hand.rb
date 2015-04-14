module Blackjack
  class DealerHand < Hand
    MINIMUM_POINTS_DEALER_SHOULD_HAVE_TO_STOP_HITTING = 17

    def full?
      score >= MINIMUM_POINTS_DEALER_SHOULD_HAVE_TO_STOP_HITTING
    end
  end
end
