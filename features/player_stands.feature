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

    Scenarios: stand
      | player_hand | player_score | given_dealer_hand | deck  | final_dealer_hand | dealer_score | result        |
      | T♥ J♥       | 20           | T♦ A♦             |       | T♦ A♦             | 21           | You loose!    |
      | T♥ J♥       | 20           | T♦ 7♦             |       | T♦ 7♦             | 17           | You win!      |
      | T♥ J♥       | 20           | T♦ 6♦             | 4♦    | T♦ 6♦ 4♦          | 20           | You push!     |
      | T♥ J♥       | 20           | T♦ 6♦             | 5♦    | T♦ 6♦ 5♦          | 21           | You loose!    |
      | T♥ J♥       | 20           | T♦ 6♦             | 7♦    | T♦ 6♦ 7♦          | 23           | You win!      |

  Scenario Outline: bets
    Given the player hand is "<player_hand>"
    And the dealer hand is "<dealer_hand>"
    And the player money is "900"
    And the bet is "100"
    And the deck is ""
    And the game is started
    When I stand
    Then I should see "Your money: <player_money>."

    Scenarios: bets
      | player_hand | player_score | dealer_hand | dealer_score | player_money |
      | T♥ J♥       | 20           | T♦ A♦       | 21           | 900          |
      | T♥ J♥       | 20           | T♦ J♦       | 20           | 1000         |
      | T♥ J♥       | 20           | T♦ 7♦       | 17           | 1100         |

  Scenario: stand before the round has been started
    Given the round hasn't been started
    When I stand
    Then I should see "The round hasn't been started yet."
