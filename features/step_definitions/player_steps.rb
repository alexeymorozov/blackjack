Given("I am not yet playing") do
end

Given(/^the player money is "(.*?)"$/) do |player_money|
  @player_money = player_money.to_i
end

Given(/^the bet is "(.*?)"$/) do |bet|
  @bet = bet.to_i
end

Given(/^the deck is "(.*?)"$/) do |deck|
  @deck = deck
end

Given(/^the player hand is "(.*?)"$/) do |card_codes|
  @player_hand = card_codes
end

Given(/^the dealer hand is "(.*?)"$/) do |card_codes|
  @dealer_hand = card_codes
end

When(/^I start a new game$/) do
  @game = Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer)))
  @game.start
end

Given(/^the game is started$/) do
  @bet ||= 1
  @player_money ||= 1000
  @game = Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer)))
  @game.start_from_saving(@deck, @player_hand, @dealer_hand, @bet, @player_money)
end

Given(/^the round hasn't been started$/) do
  @game = Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer)))
end

Given(/^the round has already been started$/) do
  @game = Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer)))
  @game.deck_from_string("2♥ 2♦ 3♥ 3♦")
  @game.bet(1)
end

Given(/^the round has been started and finished$/) do
  @game = Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer)))
  @game.deck_from_string(@deck)
  @game.bet(1)
  @game.new_round
end

Given(/^the game is over$/) do
  @game = Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer)))
  @game.deck_from_string("")
  @game.bet(1)
end

When(/^I start a new round$/) do
  @bet ||= 1
  @deck ||= "2♥ 2♦ 3♥ 3♦"
  @game ||= Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer)))
  @player_money ||= 1000
  @game.player_money = @player_money
  @game.deck_from_string(@deck)
  @game.bet(@bet)
end

When(/^I start a new round without a deck$/) do
  @game.bet(1)
end

When(/^I hit$/) do
  @game.hit
end

When(/^I stand$/) do
  @game.stand
end

Then(/^I should see "(.*?)"$/) do |message|
  expect(printer.messages).to include(message)
end

class Printer
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message
  end
end

def printer
  @printer ||= Printer.new
end
