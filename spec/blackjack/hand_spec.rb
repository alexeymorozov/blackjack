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

      context "two cards" do
        it "returns sum of the cards values" do
          two = Card.new('2♥').face_up
          three = Card.new('3♥').face_up
          hand = Hand.new([two, three])
          expect(hand.score).to eq(5)
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
