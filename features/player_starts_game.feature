Feature: player starts game

  The player starts the game. The game tells whether the player wins, pushes,
  or can continue the round.

  If the player gets 21 points, he either win or push. If his score is less
  than 21 points, he can continue to play the round.

  Score is calculated by the rules:
    - ace: 1 or 11 points (11 until the score is less or equal to 21)
    - face cards (kings, queens, jacks): 10 points
    - all other cards: their numeric value

  Scenario Outline: start game
    Given I am not yet playing
    And the deck is "<deck>"
    When I start a new game
    Then I should see "Welcome to Blackjack!"
    And I should see "Dealer's hand: <dealer_hand>. Score: <dealer_score>."
    And I should see "Your hand: <player_hand>. Score: <player_score>."
    And I should see "<result>"

    Scenarios: blackjacks
      | deck        | player_hand | player_score | dealer_hand | dealer_score | result    |
      | A♥ Q♦ J♥ J♦ | A♥ J♥       | 21           | Q♦ J♦       | 20           | You win!  |
      | A♥ A♦ J♥ J♦ | A♥ J♥       | 21           | A♦ J♦       | 21           | You push! |

    Scenarios: player has less than 21
      | deck        | player_hand | player_score | dealer_hand | dealer_score | result        |
      | Q♥ A♦ J♥ J♦ | Q♥ J♥       | 20           | A♦ ?        | 11           | Enter action: |
      | Q♥ Q♦ J♥ J♦ | Q♥ J♥       | 20           | Q♦ ?        | 10           | Enter action: |
      | 3♥ Q♦ 2♥ J♦ | 3♥ 2♥       | 5            | Q♦ ?        | 10           | Enter action: |
      | A♥ Q♦ A♠ J♦ | A♥ A♠       | 12           | Q♦ ?        | 10           | Enter action: |
