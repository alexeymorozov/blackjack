Given("I am not yet playing") do
end

Given(/^the deck is "(.*?)"$/) do |deck|
  @game = Blackjack::Game.new(printer)
  @deck = deck
end

When(/^I start a new game$/) do
  @game.start(@deck)
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
