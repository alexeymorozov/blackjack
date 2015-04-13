require 'spec_helper'

module Blackjack
  describe Card do
    let(:card) { Card.new('A♥') }

    describe "#to_s" do
      context "face down" do
        it "returns a question mark" do
          expect(card.to_s).to eq('?')
        end
      end

      context "face up" do
        it "returns the code of the card" do
          expect(card.face_up.to_s).to eq('A♥')
        end
      end
    end

    describe "#face_up?" do
      it "returns false for a new card" do
        expect(card.face_up?).to be false
      end
    end

    describe "#face_down?" do
      it "is opposite of face_up?" do
        expect(card.face_down?).to be !card.face_up?
      end
    end

    describe "#face_up" do
      it "flips a card face up" do
        card.face_up
        expect(card.face_up?).to be true
      end

      it "returns self" do
        expect(card.face_up).to be(card)
      end
    end

    describe "#rank" do
      it "returns the rank of the card" do
        expect(card.rank).to eq('A')
      end
    end

    describe "#suit" do
      it "returns the suit of the card" do
        expect(card.suit).to eq('♥')
      end
    end
  end
end
