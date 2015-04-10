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

      it "sends hands and score" do
          expect(printer).to receive(:puts).with("Dealer's hand: Q♦ J♦. Score: 20.")
          expect(printer).to receive(:puts).with("Your hand: A♥ J♥. Score: 21.")
          game.start("A♥ Q♦ J♥ J♦")
      end

      context "player has a blackjack, without a dealer blackjack" do
        it "shows that the player wins" do
          expect(printer).to receive(:puts).with("You win!")
          game.start("A♥ Q♦ J♥ J♦")
        end
      end

      context "the player and dealer both have blackjacks" do
        it "shows that the player pushes" do
          expect(printer).to receive(:puts).with("You push!")
          game.start("A♥ A♦ J♥ J♦")
        end
      end
    end
  end
end
