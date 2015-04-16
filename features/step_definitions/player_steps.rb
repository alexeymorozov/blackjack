Given("I am not yet playing") do
end

Given(/^the round is started$/) do
  @game = create_game
  @game.start_round
end

Given(/^the round is started with the deck "(.*?)"$/) do |card_codes|
  deck = create_deck(card_codes)
  @game = create_game(deck)
  @game.start_round
end

Given(/^the bet "(.*?)" has been already done$/) do |amount|
  @game.bet(amount)
end

Given(/^the bet hasn't been done yet$/) do
end

Given(/^the game is dealt with the player hand "(.*?)", the dealer hand "(.*?)", and the deck "(.*?)"$/) do |player_hand, dealer_hand, deck_card_codes|
  card_codes = player_hand.split.zip(dealer_hand.split).flatten.compact + deck_card_codes.split
  deck = create_deck(card_codes.join(' '))
  @game = create_game(deck)
  @game.start_round
end

When(/^I start a new round$/) do
  @game = create_game
  @game.start_round
end

When(/^I bet "(.*?)"$/) do |amount|
  @game.bet((amount || 1).to_i)
end

When(/^I stand$/) do
  @game.stand
end

When(/^I hit$/) do
  @game.hit
end

Then(/^I should see "(.*?)"$/) do |message|
  expect(printer.messages).to include(message)
end

def create_game(deck = nil)
  Blackjack::GameCLI.new(Blackjack::Game.new(Blackjack::MessageSender.new(printer), deck))
end

def create_deck(card_codes)
  Blackjack::Deck.create_from_string(card_codes)
end

def printer
  @printer ||= Printer.new
end

class Printer
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message
  end
end
