module Blackjack
  module Command
    class ResolveCommand
      def initialize(message_sender)
        @message_sender = message_sender
      end

      def can_be_run?(player_hands)
        all_hands_are_finished?(player_hands) && !all_hands_are_busted?(player_hands)
      end

      def run(player_money, deck, player_hands, dealer_hand, current_hand)
        @player_money = player_money
        @deck = deck
        @player_hands = player_hands
        @dealer_hand = dealer_hand
        resolve_dealer_hand
        handle_result_for_each_hands
        [nil, @player_money]
      end

      private

      def all_hands_are_finished?(player_hands)
        player_hands.all? { |hand| hand.finished? }
      end

      def all_hands_are_busted?(player_hands)
        player_hands.all? { |hand| hand.busted? }
      end

      def resolve_dealer_hand
        @dealer_hand.face_up
        while !@dealer_hand.full? && !@player_hands.first.has_blackjack?
          @dealer_hand << @deck.pop.face_up
        end
      end

      def handle_result_for_each_hands
        @player_hands.each do |hand|
          @current_hand = hand
          @message_sender.show_hands(@dealer_hand, @current_hand)
          handle_result
        end
      end

      def handle_result
        if @current_hand.busted?
          handle_loss
        elsif @dealer_hand.busted?
          handle_win
        elsif @current_hand > @dealer_hand
          handle_win
        elsif @current_hand < @dealer_hand
          handle_loss
        else
          handle_push
        end
      end

      def handle_win
        @message_sender.send_win
        @player_money += (@current_hand.bet * (@current_hand.has_blackjack? ? 2.5 : 2)).to_i
        @message_sender.show_money(@player_money)
      end

      def handle_loss
        @message_sender.send_loss
        @message_sender.show_money(@player_money)
      end

      def handle_push
        @message_sender.send_push
        @player_money += @current_hand.bet
        @message_sender.show_money(@player_money)
      end
    end
  end
end