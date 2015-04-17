require 'spec_helper'

module Blackjack
  describe GameCLI do
    let(:printer) { double('printer').as_null_object }
    let(:game) { GameCLI.new(Game.new, MessageSender.new(printer)) }

    def start_game(card_string = nil, player_money = nil)
      deck = card_string ? Deck.create_from_string(card_string) : nil
      game = GameCLI.new(Game.new(deck, player_money), MessageSender.new(printer))
      game.start_round
      game
    end

    describe "#start_round" do
      after :example do
        game.start_round
      end

      it "sends a welcome message" do
        expect(printer).to receive(:puts).with('Welcome to Blackjack!')
      end

      it "sends the player's money" do
        expect(printer).to receive(:puts).with("Your money: 1000.")
      end

      it "prompts for the first bet" do
        expect(printer).to receive(:puts).with('Enter bet:')
      end
    end

    describe "#bet" do
      context "no cards left in the deck" do
        it "sends an error message" do
          game = start_game("2♥")
          expect(printer).to receive(:puts).with("No cards left in the deck. Game over!")
          game.bet(1)
        end
      end

      context "no money left" do
        it "sends an error message" do
          game = start_game(nil, 0)
          expect(printer).to receive(:puts).with("The game is over.")
          game.bet(1)
        end
      end

      context "the round has been already started" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦ 2♥ 2♦ 3♥ 3♦")
          game.bet(1)
          expect(printer).to receive(:puts).with("The betting has already been done.")
          game.bet(1)
        end
      end

      context "the round has been started, finished, and started again" do
        it "prompts the player for the next action" do
          game = start_game("A♥ 2♦ J♥ 3♦ 4♥ 4♦ 5♥ 5♦")
          game.bet(1)
          expect(printer).to receive(:puts).with("Enter action:")
          game.start_round
          game.bet(1)
        end
      end

      context "the bet is lower than the minimum bet" do
        it "chooses the minimum bet" do
          expect(printer).to receive(:puts).with("Your money: 999. Bet: 1.")
          game = start_game("2♥ 2♦ 3♥ 3♦")
          game.bet(-1)
        end
      end

      context "the bet is higher than the player's money" do
        it "chooses all the player's money as a bet" do
          expect(printer).to receive(:puts).with("Your money: 0. Bet: 1000.")
          game = start_game("2♥ 2♦ 3♥ 3♦")
          game.bet(1500)
        end
      end

      context "the bet is not integer" do
        it "coerces the value to an integer" do
          expect(printer).to receive(:puts).with("Your money: 998. Bet: 2.")
          game = start_game("2♥ 2♦ 3♥ 3♦")
          game.bet(2.5)
        end
      end

      it "sends the player's hand and score" do
        game = start_game("A♥ Q♦ J♥ J♦")
        expect(printer).to receive(:puts).with("Your hand: A♥ J♥. Score: 21.")
        game.bet(1)
      end

      context "blackjacks" do
        it "sends the dealer's hand face up and score" do
          game = start_game("A♥ Q♦ J♥ J♦")
          expect(printer).to receive(:puts).with("Dealer's hand: Q♦ J♦. Score: 20.")
          game.bet(1)
        end

        context "only the player has a blackjack" do
          it "sends that the player wins" do
            game = start_game("A♥ Q♦ J♥ J♦")
            expect(printer).to receive(:puts).with("You win!")
            game.bet(1)
          end

          it "returns the bet and pays at 3:2" do
            game = start_game("A♥ 2♦ J♥ 3♦")
            expect(printer).to receive(:puts).with("Your money: 1150.")
            game.bet(100)
          end
        end

        context "the player and dealer both have blackjacks" do
          it "sends that the player pushes" do
            game = start_game("A♥ A♦ J♥ J♦")
            expect(printer).to receive(:puts).with("You push!")
            game.bet(1)
          end
        end
      end

      context "the player has less than 21 points" do
        it "sends the dealer's hand with the second card face down" do
          game = start_game("Q♥ A♦ J♥ J♦")
          expect(printer).to receive(:puts).with("Dealer's hand: A♦ ?. Score: 11.")
          game.bet(1)
        end

        it "prompts the player for the next action" do
          game = start_game("Q♥ A♦ J♥ J♦")
          expect(printer).to receive(:puts).with("Enter action:")
          game.bet(1)
        end
      end
    end

    describe "#hit" do
      context "no cards left in the deck" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦")
          game.bet(1)
          expect(printer).to receive(:puts).with("No cards left in the deck. Game over!")
          game.hit
        end
      end

      context "the betting hasn't been completed yet" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦")
          expect(printer).to receive(:puts).with("The betting hasn't been completed yet.")
          game.hit
        end
      end

      context "the player has less than 21 after hitting" do
        before :example do
          @game = start_game("2♥ 2♦ 3♥ 3♦ 4♥")
          @game.bet(1)
        end

        after :example do
          @game.hit
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
    end

    describe "#stand" do
      context "no cards left in the deck" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦")
          game.bet(1)
          expect(printer).to receive(:puts).with("No cards left in the deck. Game over!")
          game.stand
        end
      end

      context "the betting hasn't been completed yet" do
        it "sends an error message" do
          game = start_game("2♥")
          expect(printer).to receive(:puts).with("The betting hasn't been completed yet.")
          game.stand
        end
      end

      it "shows result" do
        game = start_game('T♥ T♦ J♥ A♦')
        game.bet(1)
        expect(printer).to receive(:puts).with("You loose!")
        game.stand
      end
    end
  end
end
