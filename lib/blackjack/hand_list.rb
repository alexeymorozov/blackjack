module Blackjack
  class HandList < Array
    attr_accessor :current

    def all_finished?
      all? { |hand| hand.finished? }
    end

    def all_busted?
      all? { |hand| hand.busted? }
    end

    def all_have_blackjacks?
      all? { |hand| hand.has_blackjack? }
    end

    def all_have_bets?
      all? { |hand| hand.bet }
    end

    def dealt?
      any? { |hand| hand.dealt? }
    end
  end
end
