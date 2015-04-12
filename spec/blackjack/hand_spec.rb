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

      context "hand of one card" do
        it "returns the value of a card" do
          card_values = {
            'A♥' => 11,
            'K♥' => 10,
            'Q♥' => 10,
            'J♥' => 10,
            'T♥' => 10,
            '9♥' => 9,
            '8♥' => 8,
            '7♥' => 7,
            '6♥' => 6,
            '5♥' => 5,
            '4♥' => 4,
            '3♥' => 3,
            '2♥' => 2,
          }

          card_values.each do |code, value|
            hand = Hand.new
            hand << Card.new(code).face_up
            expect(hand.score).to be value
          end
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
