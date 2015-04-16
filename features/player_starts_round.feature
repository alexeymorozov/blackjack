Feature: player starts round

  As a player
  I want to start a new round
  So that I can play blackjack

  Scenario: start round
    Given I am not yet playing
    When I start a new round
    Then I should see "Welcome to Blackjack!"
    And I should see "Your money: 1000."
    And I should see "Enter bet:"
