Feature: player hits

  The player hits (takes another card). The game tells whether the player wins, 
  pushes, looses, or can continue the round.

  The winner is determined by the same rules as after initial deal with some 
  additional terms:
    - blackjack (21 in two cards) beats 21 in three or more cards
    - if the player gets more than 21 points, he looses

  When the player gets 21 points, the dealer takes cards until the hand achieves
  a value of 17 or higher.

  Scenario Outline: hit
    Given the game is dealt with the player hand "<given_player_hand>", the dealer hand "<given_dealer_hand>", and the deck "<deck>"
    And the bet "1" has been already done
    When I hit
    Then I should see "Dealer's hand: <final_dealer_hand>. Score: <dealer_score>."
    And I should see "Your hand: <final_player_hand>. Score: <player_score>."
    And I should see "<result>"

    Examples:
      | deck     | given_player_hand | final_player_hand | player_score | given_dealer_hand | final_dealer_hand | dealer_score | result        |
      | 4♥       | 2♥ 3♥             | 2♥ 3♥ 4♥          | 9            | 2♦ 3♦             | 2♦ ?              | 2            | Enter action: |
      | 8♥       | 6♥ 7♥             | 6♥ 7♥ 8♥          | 21           | T♦ 7♦             | T♦ 7♦             | 17           | You win!      |
      | 8♥       | 6♥ 7♥             | 6♥ 7♥ 8♥          | 21           | T♦ K♦             | T♦ K♦             | 20           | You win!      |
      | 8♥ 4♦    | 6♥ 7♥             | 6♥ 7♥ 8♥          | 21           | T♦ 6♦             | T♦ 6♦ 4♦          | 20           | You win!      |
      | 8♥ 3♦ 2♦ | 6♥ 7♥             | 6♥ 7♥ 8♥          | 21           | 7♦ 6♦             | 7♦ 6♦ 3♦ 2♦       | 18           | You win!      |
      | 8♥ 5♦    | 6♥ 7♥             | 6♥ 7♥ 8♥          | 21           | T♦ 6♦             | T♦ 6♦ 5♦          | 21           | You push!     |
      | 8♥       | 6♥ 7♥             | 6♥ 7♥ 8♥          | 21           | T♦ A♦             | T♦ A♦             | 21           | You loose!    |
      | 9♥       | 6♥ 7♥             | 6♥ 7♥ 9♥          | 22           | 2♦ 3♦             | 2♦ ?              | 2            | You loose!    |
      | 8♥ 7♦    | 6♥ 7♥             | 6♥ 7♥ 8♥          | 21           | T♦ 6♦             | T♦ 6♦ 7♦          | 23           | You win!      |

  Scenario: stand before the betting
    Given the round is started
    And the bet hasn't been done yet
    When I stand
    Then I should see "The betting hasn't been completed yet."
