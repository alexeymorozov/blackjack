require 'spec_helper'

module Blackjack
  describe Game do
    let(:printer) { double('printer').as_null_object }
    let(:game) { Game.new(printer) }

    describe "#start" do
      it "sends a welcome message" do
        expect(printer).to receive(:puts).with('Welcome to Blackjack!')
        game.start
      end

      it "prompts for the first bet" do
        expect(printer).to receive(:puts).with('Enter bet:')
        game.start
      end
    end

    describe "#start_round" do
      it "sends the player's hand and score" do
        expect(printer).to receive(:puts).with("Your hand: A♥ J♥. Score: 21.")
        game.start_round("A♥ Q♦ J♥ J♦")
      end

      context "blackjacks" do
        it "sends the dealer's hand face up and score" do
            expect(printer).to receive(:puts).with("Dealer's hand: Q♦ J♦. Score: 20.")
            game.start_round("A♥ Q♦ J♥ J♦")
        end

        context "only the player has a blackjack" do
          it "sends that the player wins" do
            expect(printer).to receive(:puts).with("You win!")
            game.start_round("A♥ Q♦ J♥ J♦")
          end

          it "gives the dealer no more cards" do
            expect(printer).to receive(:puts).with("Dealer's hand: T♦ 6♦. Score: 16.")
            game.start_round("A♥ T♦ J♥ 6♦")
          end
        end

        context "the player and dealer both have blackjacks" do
          it "sends that the player pushes" do
            expect(printer).to receive(:puts).with("You push!")
            game.start_round("A♥ A♦ J♥ J♦")
          end
        end
      end

      context "the player has less than 21 points" do
        it "sends the dealer's hand with the second card face down" do
          expect(printer).to receive(:puts).with("Dealer's hand: A♦ ?. Score: 11.")
          game.start_round("Q♥ A♦ J♥ J♦")
        end

        it "prompts the player for the next action" do
          expect(printer).to receive(:puts).with("Enter action:")
          game.start_round("Q♥ A♦ J♥ J♦")
        end
      end

      context "the player score equals the value of the dealer's first card" do
        it "doesn't flip the dealer's second card face up" do
          expect(printer).to receive(:puts).with("Dealer's hand: 5♦ ?. Score: 5.")
          game.start_round("2♥ 5♦ 3♥ J♦")
        end
      end
    end

    describe "#hit" do
      context "the player has less than 21 after hitting" do
        before :example do
          game.start_from_saving('4♥', '2♥ 3♥', '2♦ 3♦')
        end

        after :example do
          game.hit
        end

        it "sends the player's hand with a new card" do
          expect(printer).to receive(:puts).with("Your hand: 2♥ 3♥ 4♥. Score: 9.")
        end

        it "sends the dealer's hand untouched" do
          expect(printer).to receive(:puts).with("Dealer's hand: 2♦ ?. Score: 2.")
        end

        it "prompts the player for the next action" do
          expect(printer).to receive(:puts).with("Enter action:")
        end
      end

      context "the player has 21 points after hitting and the dealer has 17 points" do
        it "sends that the player wins" do
          game.start_from_saving('8♥', '6♥ 7♥', 'T♦ 7♦')
          expect(printer).to receive(:puts).with("You win!")
          game.hit
        end
      end

      context "the player has 21 points after hitting and the dealer has 16 points" do
        it "gives the dealer a card" do
          game.start_from_saving('8♥ 4♦', '6♥ 7♥', 'T♦ 6♦')
          expect(printer).to receive(:puts).with("Dealer's hand: T♦ 6♦ 4♦. Score: 20.")
          game.hit
        end
      end

      context "the player has 21 points after hitting and the dealer has 13 points" do
        it "gives the dealer a card until he has at least 17 points" do
          game.start_from_saving('8♥ 3♦ 2♦', '6♥ 7♥', '7♦ 6♦')
          expect(printer).to receive(:puts).with("Dealer's hand: 7♦ 6♦ 3♦ 2♦. Score: 18.")
          game.hit
        end
      end

      context "the player has 21 points after hitting and the dealer has blackjack in two cards" do
        it "sends that the player looses" do
          game.start_from_saving('8♥', '6♥ 7♥', 'T♦ A♦')
          expect(printer).to receive(:puts).with("You loose!")
          game.hit
        end
      end

      context "the player has 22 points after hitting" do
        it "sends that the player looses" do
          game.start_from_saving('9♥', '6♥ 7♥', '2♦ 3♦')
          expect(printer).to receive(:puts).with("You loose!")
          game.hit
        end
      end

      context "the player gets 21 points and the dealer gets more than 21 points" do
        it "sends that the player wins" do
          game.start_from_saving('8♥ 7♦', '6♥ 7♥', 'T♦ 6♦')
          expect(printer).to receive(:puts).with("You win!")
          game.hit
        end
      end
    end

    describe "#stand" do
      it "shows result" do
          game.start_from_saving('', 'T♥ J♥', 'T♦ A♦')
          expect(printer).to receive(:puts).with("You loose!")
          game.stand
      end
    end
  end
end
