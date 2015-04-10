Given("I am not yet playing") do
end

Given(/^the deck is "(.*?)"$/) do |deck|
  @deck = deck
end

Given(/^the player hand is "(.*?)"$/) do |card_codes|
  cards = card_codes.split.map { |code| Blackjack::Card.new(code).face_up }
  @player_hand = Blackjack::Hand.new(cards)
end

Given(/^the dealer hand is "(.*?)"$/) do |card_codes|
  cards = card_codes.split.map { |code| Blackjack::Card.new(code).face_up }
  @dealer_hand = Blackjack::Hand.new(cards)
end

Given(/^the game is started$/) do
  @game = Blackjack::Game.new(printer)
  @game.start_from_saving(@deck, @player_hand, @dealer_hand)
end

When(/^I start a new game$/) do
  @game = Blackjack::Game.new(printer)
  @game.start(@deck)
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
