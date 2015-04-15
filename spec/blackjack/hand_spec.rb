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
        Hand.new([card]).face_up
        expect(card.face_up?).to be true
      end
    end

    describe "#score" do
      context "hand of one card" do
        it "returns the value of a card" do
          hand = Hand.new
          hand << Card.new('2♥').face_up
          expect(hand.score).to be 2
        end
      end

      context "two cards" do
        it "returns sum of the cards values" do
          cards = ['2♥', '3♠'].map { |code| Card.new(code).face_up }
          hand = Hand.new(cards)
          expect(hand.score).to eq(5)
        end
      end

      context "one ace" do
        it "returns 11" do
          hand = Hand.new
          hand << Card.new('A♥').face_up
          expect(hand.score).to eq(11)
        end
      end

      context "two aces" do
        it "returns 12" do
          cards = ['A♥', 'A♠'].map { |code| Card.new(code).face_up }
          hand = Hand.new(cards)
          expect(hand.score).to eq(12)
        end
      end

      context "two aces and ten" do
        it "returns 12" do
          cards = ['A♥', 'A♠', 'T♥'].map { |code| Card.new(code).face_up }
          hand = Hand.new(cards)
          expect(hand.score).to eq(12)
        end
      end

      context "face-down card" do
        it "returns 0" do
          face_down_card = Card.new('J♥')
          hand = Hand.new([face_down_card])
          expect(hand.score).to eq(0)
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
