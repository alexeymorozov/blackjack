require 'spec_helper'

module Blackjack
  describe Game do
    let(:printer) { double('printer').as_null_object }
    let(:game) { GameCLI.new(Game.new(MessageSender.new(printer))) }
    let(:pure_game) { Game.new(MessageSender.new(printer)) }

    before :example do
      game.start_round
      pure_game.start_round
    end

    describe "#start" do
      it "sends a welcome message" do
        expect(printer).to receive(:puts).with('Welcome to Blackjack!')
        game.start
      end

      it "sends the player's money" do
        expect(printer).to receive(:puts).with("Your money: 1000.")
        game.start
      end

      it "prompts for the first bet" do
        expect(printer).to receive(:puts).with('Enter bet:')
        game.start
      end
    end

    describe "#bet" do
      context "no cards left in the deck" do
        it "sends an error message" do
          expect(printer).to receive(:puts).with("No cards left in the deck. Game over!")
          game.deck_from_string("2♥")
          game.bet(1)
        end
      end

      context "no money left" do
        it "sends an error message" do
          expect(printer).to receive(:puts).with("The game is over.")
          game.player_money = 0
          game.deck_from_string("2♥ 2♦ 3♥ 3♦")
          game.bet(1)
        end
      end

      context "game is over" do
        it "sends an error message" do
          game.deck_from_string("")
          game.bet(1)
          expect(printer).to receive(:puts).with("The game is over.")
          game.bet(1)
        end
      end

      context "the round has been already started" do
        it "sends an error message" do
          game.deck_from_string("2♥ 2♦ 3♥ 3♦ 2♥ 2♦ 3♥ 3♦")
          game.bet(1)
          expect(printer).to receive(:puts).with("The betting has already been done.")
          game.bet(1)
        end
      end

      context "the round has been started, finished, and started again" do
        it "prompts the player for the next action" do
          game.deck_from_string("A♥ 2♦ J♥ 3♦")
          game.bet(1)
          expect(printer).to receive(:puts).with("Enter action:")
          game.start_round
          game.deck_from_string("2♥ 2♦ 3♥ 3♦")
          game.bet(1)
        end
      end

      context "called without a deck" do
        it "uses a deck from the previous round" do
          game.deck_from_string("A♥ 2♦ J♠ 3♦ K♥ 4♦ T♠ 5♦")
          game.bet(1)
          expect(printer).to receive(:puts).with("Enter action:")
          game.start_round
          game.bet(1)
        end
      end

      context "the bet is lower than the minimum bet" do
        it "chooses the minimum bet" do
          expect(printer).to receive(:puts).with("Your money: 999. Bet: 1.")
          game.deck_from_string("2♥ 2♦ 3♥ 3♦")
          game.bet(-1)
        end
      end

      context "the bet is higher than the player's money" do
        it "chooses all the player's money as a bet" do
          expect(printer).to receive(:puts).with("Your money: 0. Bet: 1000.")
          game.deck_from_string("2♥ 2♦ 3♥ 3♦")
          game.bet(1500)
        end
      end

      context "the bet is not integer" do
        it "coerces the value to an integer" do
          expect(printer).to receive(:puts).with("Your money: 998. Bet: 2.")
          game.deck_from_string("2♥ 2♦ 3♥ 3♦")
          game.bet(2.5)
        end
      end

      context "correct bet" do
        it "sends the player's money and bet" do
          expect(printer).to receive(:puts).with("Your money: 900. Bet: 100.")
          game.deck_from_string("2♥ 2♦ 3♥ 3♦")
          game.bet(100)
        end
      end

      it "sends the player's hand and score" do
        expect(printer).to receive(:puts).with("Your hand: A♥ J♥. Score: 21.")
        game.deck_from_string("A♥ Q♦ J♥ J♦")
        game.bet(1)
      end

      context "blackjacks" do
        it "sends the dealer's hand face up and score" do
            expect(printer).to receive(:puts).with("Dealer's hand: Q♦ J♦. Score: 20.")
            game.deck_from_string("A♥ Q♦ J♥ J♦")
            game.bet(1)
        end

        context "only the player has a blackjack" do
          it "sends that the player wins" do
            expect(printer).to receive(:puts).with("You win!")
            game.deck_from_string("A♥ Q♦ J♥ J♦")
            game.bet(1)
          end

          it "returns the bet and pays at 3:2" do
          expect(printer).to receive(:puts).with("Your money: 1150.")
            game.deck_from_string("A♥ 2♦ J♥ 3♦")
            game.bet(100)
          end

          it "gives the dealer no more cards" do
            expect(printer).to receive(:puts).with("Dealer's hand: T♦ 6♦. Score: 16.")
            game.deck_from_string("A♥ T♦ J♥ 6♦")
            game.bet(1)
          end
        end

        context "the player and dealer both have blackjacks" do
          it "sends that the player pushes" do
            expect(printer).to receive(:puts).with("You push!")
            game.deck_from_string("A♥ A♦ J♥ J♦")
            game.bet(1)
          end
        end
      end

      context "the player has less than 21 points" do
        it "sends the dealer's hand with the second card face down" do
          expect(printer).to receive(:puts).with("Dealer's hand: A♦ ?. Score: 11.")
          game.deck_from_string("Q♥ A♦ J♥ J♦")
          game.bet(1)
        end

        it "prompts the player for the next action" do
          expect(printer).to receive(:puts).with("Enter action:")
          game.deck_from_string("Q♥ A♦ J♥ J♦")
          game.bet(1)
        end
      end

      context "the player score equals the value of the dealer's first card" do
        it "doesn't flip the dealer's second card face up" do
          expect(printer).to receive(:puts).with("Dealer's hand: 5♦ ?. Score: 5.")
          game.deck_from_string("2♥ 5♦ 3♥ J♦")
          game.bet(1)
        end
      end
    end

    describe "#hit" do
      context "game is over" do
        it "sends an error message" do
          game.deck_from_string("2♥")
          game.bet(1)
          expect(printer).to receive(:puts).with("No cards left in the deck. Game over!")
          game.hit
        end
      end

      context "the betting hasn't been completed yet" do
        it "sends an error message" do
          expect(printer).to receive(:puts).with("The betting hasn't been completed yet.")
          game.hit
        end
      end

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
      context "game is over" do
        it "sends an error message" do
          game.deck_from_string("2♥")
          expect(printer).to receive(:puts).with("No cards left in the deck. Game over!")
          game.bet(1)
          game.stand
        end
      end

      context "the betting hasn't been completed yet" do
        it "sends an error message" do
          expect(printer).to receive(:puts).with("The betting hasn't been completed yet.")
          game.stand
        end
      end

      it "shows result" do
          game.start_from_saving('', 'T♥ J♥', 'T♦ A♦')
          expect(printer).to receive(:puts).with("You loose!")
          game.stand
      end

      context "the player looses" do
        it "doesn't return the bet" do
            game.start_from_saving('', 'T♥ J♥', 'T♦ A♦', 100, 900)
            expect(printer).to receive(:puts).with("Your money: 900.")
            game.stand
        end
      end

      context "the player pushes" do
        it "returns the bet" do
          game.start_from_saving('', 'T♥ J♥', 'T♦ J♦', 100, 900)
          expect(printer).to receive(:puts).with("Your money: 1000.")
          game.stand
        end
      end

      context "the player wins" do
        it "returns the bet and pays at 1:1" do
          game.start_from_saving('', 'T♥ J♥', 'T♦ 7♦', 100, 900)
          expect(printer).to receive(:puts).with("Your money: 1100.")
          game.stand
        end
      end
    end
  end
end
