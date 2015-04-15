Feature: player starts game

  As a player
  I want to start a game
  So that I can play blackjack

  Scenario: start game
    Given I am not yet playing
    When I start a new game
    Then I should see "Welcome to Blackjack!"
    And I should see "Your money: 1000."
    And I should see "Enter bet:"
