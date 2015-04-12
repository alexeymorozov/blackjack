require 'spec_helper'

module Blackjack
  describe Game do
    describe "#start" do
      let(:printer) { double('printer').as_null_object }
      let(:game) { Game.new(printer) }

      it "sends a welcome message" do
        expect(printer).to receive(:puts).with('Welcome to Blackjack!')
        game.start("A♥ Q♦ J♥ J♦")
      end

      it "sends the player's hand and score" do
        expect(printer).to receive(:puts).with("Your hand: A♥ J♥. Score: 21.")
        game.start("A♥ Q♦ J♥ J♦")
      end

      context "blackjacks" do
        it "sends the dealer's hand face up and score" do
            expect(printer).to receive(:puts).with("Dealer's hand: Q♦ J♦. Score: 20.")
            game.start("A♥ Q♦ J♥ J♦")
        end

        context "only the player has a blackjack" do
          it "sends that the player wins" do
            expect(printer).to receive(:puts).with("You win!")
            game.start("A♥ Q♦ J♥ J♦")
          end
        end

        context "the player and dealer both have blackjacks" do
          it "sends that the player pushes" do
            expect(printer).to receive(:puts).with("You push!")
            game.start("A♥ A♦ J♥ J♦")
          end
        end
      end

      context "the player has less than 21 points" do
        it "sends the dealer's hand with the second card face down" do
          expect(printer).to receive(:puts).with("Dealer's hand: A♦ ?. Score: 11.")
          game.start("Q♥ A♦ J♥ J♦")
        end
      end
    end
  end
end
