require 'spec_helper'

module Blackjack
  describe Hand do
    describe "#receive" do
      it "receives a card" do
        Hand.new.receive 'A♥'
      end
    end

    describe "#score" do
      context "blackjack" do
        it "returns 21" do
          expect(Hand.new(['A♥', 'Q♥']).score).to eq(21)
        end
      end

      context "two face cards" do
        it "returns 20" do
          expect(Hand.new(['Q♥', 'J♥']).score).to eq(20)
        end
      end
    end

    describe "#to_s" do
      it "returns text representation of the hand" do
        expect(Hand.new(['A♥', 'Q♥']).to_s).to eq('A♥ Q♥')
      end
    end
  end
end
