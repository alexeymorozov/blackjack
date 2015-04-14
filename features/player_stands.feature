Feature: player stands

  The player stands. The game tells whether the player wins, pushes,
  or can continue the round.
 
  The winner is determined by the same rules as after hitting, and the action 
  exists for taking no more cards before the player has 21 points.

  Scenario Outline: stand
    Given the player hand is "<player_hand>"
    And the dealer hand is "<given_dealer_hand>"
    And the deck is "<deck>"
    And the game is started
    When I stand
    Then I should see "Dealer's hand: <final_dealer_hand>. Score: <dealer_score>."
    And I should see "Your hand: <player_hand>. Score: <player_score>."
    And I should see "<result>"

    Scenarios: hit
      | player_hand | player_score | given_dealer_hand | deck  | final_dealer_hand | dealer_score | result        |
      | T♥ J♥       | 20           | T♦ A♦             |       | T♦ A♦             | 21           | You loose!    |
      | T♥ J♥       | 20           | T♦ 7♦             |       | T♦ 7♦             | 17           | You win!      |
      | T♥ J♥       | 20           | T♦ 6♦             | 4♦    | T♦ 6♦ 4♦          | 20           | You push!     |
      | T♥ J♥       | 20           | T♦ 6♦             | 5♦    | T♦ 6♦ 5♦          | 21           | You loose!    |
      | T♥ J♥       | 20           | T♦ 6♦             | 7♦    | T♦ 6♦ 7♦          | 23           | You win!      |
