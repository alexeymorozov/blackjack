require 'spec_helper'

module Blackjack
  describe Hand do
    describe "#receive" do
      it "receives a card" do
        Hand.new.receive 'A♥'
      end
    end

    describe "#face_up" do
      it "flips all cards face up" do
        card = Card.new('A♥')
        hand = Hand.new([card])
        hand.face_up
        expect(card.face_up?).to be true
      end
    end

    describe "#score" do
      context "blackjack" do
        it "returns 21" do
          hand = Hand.new(['A♥', 'Q♥'])
          hand.face_up
          expect(hand.score).to eq(21)
        end
      end

      context "two face cards" do
        it "returns 20" do
          hand = Hand.new(['Q♥', 'J♥'])
          hand.face_up
          expect(hand.score).to eq(20)
        end
      end

      context "initial dealer hand" do
        it "returns the score of the first card only" do
          hand = Hand.new
          hand << Card.new('Q♥').face_up
          hand << Card.new('J♥')
          expect(hand.score).to eq(10)
        end
      end
    end

    describe "#to_s" do
      it "returns text representation of the hand" do
        hand = Hand.new(['A♥', 'Q♥'])
        hand.face_up
        expect(hand.to_s).to eq('A♥ Q♥')
      end
    end
  end
end
