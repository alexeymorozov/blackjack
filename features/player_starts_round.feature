Feature: player starts round

  The player starts the round. The game tells whether the player wins, pushes,
  or can continue the round.

  If the player gets 21 points, he either win or push. If his score is less
  than 21 points, he can continue to play the round.

  Score is calculated by the rules:
    - ace: 1 or 11 points (11 until the score is less or equal to 21)
    - face cards (kings, queens, jacks): 10 points
    - all other cards: their numeric value

  Scenario Outline: different bets
    Given I am not yet playing
    And the bet is "<bet>"
    And the deck is "2♥ 2♦ 3♥ 3♦"
    When I start a new round
    Then I should see "Your money: <player_money>. Bet: <integer_bet>."

    Scenarios: incorrect bets
      | bet  | player_money | integer_bet |
      | -1   | 999          | 1           |
      | 0    | 999          | 1           |
      | 0.5  | 999          | 1           |
      | 1500 | 0            | 1000        |

    Scenarios: correct bets
      | bet | player_money | integer_bet |
      | 1   | 999          | 1           |
      | 1.5 | 999          | 1           |
      | 10  | 990          | 10          |

  Scenario: win with a blackjack
    Given I am not yet playing
    And the player money is "900"
    And the bet is "100"
    And the deck is "A♥ 2♦ J♥ 3♦"
    When I start a new round
    Then I should see "Your money: 1150."

  Scenario Outline: start round
    Given I am not yet playing
    And the deck is "<deck>"
    When I start a new round
    Then I should see "Dealer's hand: <dealer_hand>. Score: <dealer_score>."
    And I should see "Your hand: <player_hand>. Score: <player_score>."
    And I should see "<result>"

    Scenarios: blackjacks
      | deck        | player_hand | player_score | dealer_hand | dealer_score | result    |
      | A♥ Q♦ J♥ J♦ | A♥ J♥       | 21           | Q♦ J♦       | 20           | You win!  |
      | A♥ T♦ J♥ 6♦ | A♥ J♥       | 21           | T♦ 6♦       | 16           | You win! |
      | A♥ A♦ J♥ J♦ | A♥ J♥       | 21           | A♦ J♦       | 21           | You push! |

    Scenarios: player has less than 21
      | deck        | player_hand | player_score | dealer_hand | dealer_score | result        |
      | Q♥ A♦ J♥ J♦ | Q♥ J♥       | 20           | A♦ ?        | 11           | Enter action: |
      | Q♥ Q♦ J♥ J♦ | Q♥ J♥       | 20           | Q♦ ?        | 10           | Enter action: |
      | 3♥ Q♦ 2♥ J♦ | 3♥ 2♥       | 5            | Q♦ ?        | 10           | Enter action: |
      | A♥ Q♦ A♠ J♦ | A♥ A♠       | 12           | Q♦ ?        | 10           | Enter action: |

  Scenario: start a new round twice in a row without ending one
    Given the round has already been started
    When I start a new round
    Then I should see "The round has already been started."
