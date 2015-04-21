require 'spec_helper'

module Blackjack
  describe Game do
    let(:printer) { double('printer').as_null_object }

    def start_game(card_string = nil, player_money = nil)
      deck = card_string ? Deck.create_from_string(card_string) : nil
      game = Game.new(deck, player_money)
      game.start_round
      game
    end

    describe "#start_round" do
      context "no cards left in the deck" do
        it "raises the GameOver exception" do
          expect { start_game("") }.to raise_error(GameOver)
        end
      end

      context "no money left" do
        it "raises the GameOver exception" do
          expect { start_game(nil, 0) }.to raise_error(GameOver)
        end
      end
    end

    describe "#bet" do
      context "round is over" do
        it "raises the InvalidAction exception" do
          game = start_game("A♥ 2♦ K♥ 3♦ Q♥")
          game.bet(1)
          expect(game.round_over?).to be true
          expect { game.bet(1) }.to raise_error(InvalidAction)
        end
      end

      context "no cards left in the deck" do
        it "raises the EmptyDeck exception" do
          game = start_game("2♥")
          expect { game.bet(1) }.to raise_error(EmptyDeck)
        end
      end

      context "the round has been already started" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦ 4♥ 4♦ 5♥ 5♦")
          game.bet(1)
          expect { game.bet(1) }.to raise_error(BettingAlreadyDone)
        end
      end

      context "the round has been started, finished, and started again" do
        it "prompts the player for the next action" do
          game = start_game("A♥ 2♦ J♥ 3♦ 4♥ 4♦ 5♥ 5♦")
          game.bet(1)
          game.start_round
          game.bet(1)
          expect(game.current_hand).not_to be_nil
        end
      end

      context "the bet is lower than the minimum bet" do
        it "chooses the minimum bet" do
          game = start_game("A♥ Q♦ J♥ J♦")
          game.bet(-1)
          expect(game.player_hands.first.bet).to eq(1)
        end
      end

      context "the bet is higher than the player's money" do
        it "chooses all the player's money as a bet" do
          game = start_game("A♥ Q♦ J♥ J♦")
          game.bet(1500)
          expect(game.player_hands.first.bet).to eq(1000)
        end
      end

      context "the bet is not integer" do
        it "coerces the value to an integer" do
          game = start_game("A♥ Q♦ J♥ J♦")
          game.bet(2.5)
          expect(game.player_hands.first.bet).to eq(2)
        end
      end

      context "blackjacks" do
        it "sends the dealer's hand face up and score" do
          game = start_game("A♥ Q♦ J♥ J♦")
          game.bet(1)
          cards = game.dealer_hand.cards
          expect(cards[0].face_up?).to be true
          expect(cards[1].face_up?).to be true
        end

        context "only the player has a blackjack" do
          it "sends that the player wins" do
            game = start_game("A♥ Q♦ J♥ J♦")
            game.bet(1)
            expect(game.player_hands.first.win?).to be true
          end

          it "returns the bet and pays at 3:2" do
            game = start_game("A♥ 2♦ J♥ 3♦")
            game.bet(100)
            expect(game.player_money).to eq(1150)
          end

          it "gives the dealer no more cards" do
            game = start_game("A♥ T♦ J♥ 6♦")
            game.bet(1)
            expect(game.dealer_hand.cards.size).to eq(2)
          end
        end

        context "the player and dealer both have blackjacks" do
          it "sends that the player pushes" do
            game = start_game("A♥ A♦ J♥ J♦")
            game.bet(1)
            expect(game.player_hands.first.push?).to be true
          end
        end
      end

      context "the player has less than 21 points" do
        it "sends the dealer's hand with the second card face down" do
          game = start_game("Q♥ A♦ J♥ J♦")
          game.bet(1)
          cards = game.dealer_hand.cards
          expect(cards[0].face_up?).to be true
          expect(cards[1].face_up?).to be false
        end
      end

      context "the player score equals the value of the dealer's first card" do
        it "doesn't flip the dealer's second card face up" do
          game = start_game("2♥ 5♦ 3♥ J♦")
          game.bet(1)
          cards = game.dealer_hand.cards
          expect(cards[0].face_up?).to be true
          expect(cards[1].face_up?).to be false
        end
      end
    end

    describe "#hit" do
      def start_game_and_hit(card_string)
        game = start_game(card_string)
        game.bet(1)
        game.hit
        game
      end

      context "no cards left in the deck" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦")
          game.bet(1)
          expect { game.hit }.to raise_error(EmptyDeck)
        end
      end

      context "the betting hasn't been completed yet" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦")
          expect { game.hit }.to raise_error(BettingNotCompleted)
        end
      end

      context "the player has less than 21 after hitting" do
        it "sends the player's hand with a new card" do
          game = start_game_and_hit("2♥ 2♦ 3♥ 3♦ 4♥")
          expect(game.player_hands.first.cards.size).to eq(3)
        end

        it "sends the dealer's hand untouched" do
          game = start_game_and_hit("2♥ 2♦ 3♥ 3♦ 4♥")
          expect(game.dealer_hand.cards.size).to eq(2)
        end
      end

      context "the player has 21 points after hitting and the dealer has 17 points" do
        it "gives the dealer no card" do
          game = start_game_and_hit("6♥ T♦ 7♥ 7♦ 8♥")
          expect(game.dealer_hand.cards.size).to eq(2)
        end
      end

      context "the player has 21 points after hitting and the dealer has 16 points" do
        it "gives the dealer a card" do
          game = start_game_and_hit("6♥ T♦ 7♥ 6♦ 8♥ 4♦")
          expect(game.dealer_hand.cards.size).to eq(3)
        end
      end

      context "the player has 21 points after hitting and the dealer has 13 points" do
        it "gives the dealer a card until he has at least 17 points" do
          game = start_game_and_hit("6♥ 7♦ 7♥ 6♦ 8♥ 3♦ 2♦")
          expect(game.dealer_hand.cards.size).to eq(4)
        end
      end

      context "the player has 21 points after hitting and the dealer has blackjack in two cards" do
        it "sends that the player looses" do
          game = start_game_and_hit('6♥ T♦ 7♥ A♦ 8♥')
          expect(game.player_hands.first.loss?).to be true
        end
      end

      context "the player has 22 points after hitting" do
        it "sends that the player looses" do
          game = start_game_and_hit('6♥ 2♦ 7♥ 3♦ 9♥')
          expect(game.player_hands.first.loss?).to be true
        end
      end

      context "the player gets 21 points and the dealer gets more than 21 points" do
        it "sends that the player wins" do
          game = start_game_and_hit('6♥ T♦ 7♥ 6♦ 8♥ 7♦')
          expect(game.player_hands.first.win?).to be true
        end
      end
    end

    describe "#stand" do
      def start_game_and_stand(card_string)
        game = start_game(card_string)
        game.bet(1)
        game.stand
        game
      end

      context "no cards left in the deck" do
        it "sends an error message" do
          game = start_game("2♥ 2♦ 3♥ 3♦")
          game.bet(1)
          expect { game.stand }.to raise_error(EmptyDeck)
        end
      end

      context "the betting hasn't been completed yet" do
        it "sends an error message" do
          game = start_game("2♥")
          expect { game.stand }.to raise_error(BettingNotCompleted)
        end
      end

      context "the player looses" do
        it "doesn't return the bet" do
          game = start_game_and_stand('T♥ A♦ J♥ J♦')
          expect(game.player_money).to eq(999)
        end
      end

      context "the player pushes" do
        it "returns the bet" do
          game = start_game_and_stand('T♥ T♦ J♥ J♦')
          expect(game.player_money).to eq(1000)
        end
      end

      context "the player wins" do
        it "returns the bet and pays at 1:1" do
          game = start_game_and_stand('T♥ T♦ J♥ 7♦')
          expect(game.player_money).to eq(1001)
        end
      end
    end
  end
end
