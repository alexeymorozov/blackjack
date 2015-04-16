Feature: player bets

  The player bets. The game tells whether the player wins, pushes, or can 
  continue the round.

  If the player gets 21 points, he either win or push. If his score is less
  than 21 points, he can continue to play the round.

  Score is calculated by the rules:
    - ace: 1 or 11 points (11 until the score is less or equal to 21)
    - face cards (kings, queens, jacks): 10 points
    - all other cards: their numeric value

  Scenario Outline: bet
    Given the round is started
    When I bet "<amount>"
    Then I should see "Your money: <player_money>. Bet: <integer_bet>."

    Examples: incorrect bets
      | amount  | player_money | integer_bet |
      | -1      | 999          | 1           |
      | 0       | 999          | 1           |
      | 0.5     | 999          | 1           |
      | 1.5     | 999          | 1           |
      | 1500    | 0            | 1000        |

    Examples: correct bets
      | amount | player_money | integer_bet |
      | 1      | 999          | 1           |
      | 10     | 990          | 10          |

  Scenario: bet and win with a blackjack
    Given the round is started with the deck "A♥ 2♦ J♥ 3♦"
    When I bet "100"
    Then I should see "Your money: 1150."

  Scenario Outline: bet and see result
    Given the round is started with the deck "<deck>"
    When I bet "1"
    Then I should see "Dealer's hand: <dealer_hand>. Score: <dealer_score>."
    And I should see "Your hand: <player_hand>. Score: <player_score>."
    And I should see "<result>"

    Examples: blackjacks
      | deck        | player_hand | player_score | dealer_hand | dealer_score | result    |
      | A♥ Q♦ J♥ J♦ | A♥ J♥       | 21           | Q♦ J♦       | 20           | You win!  |
      | A♥ T♦ J♥ 6♦ | A♥ J♥       | 21           | T♦ 6♦       | 16           | You win!  |
      | A♥ A♦ J♥ J♦ | A♥ J♥       | 21           | A♦ J♦       | 21           | You push! |

    Examples: player has less than 21
      | deck        | player_hand | player_score | dealer_hand | dealer_score | result        |
      | Q♥ A♦ J♥ J♦ | Q♥ J♥       | 20           | A♦ ?        | 11           | Enter action: |
      | Q♥ Q♦ J♥ J♦ | Q♥ J♥       | 20           | Q♦ ?        | 10           | Enter action: |
      | 3♥ Q♦ 2♥ J♦ | 3♥ 2♥       | 5            | Q♦ ?        | 10           | Enter action: |
      | A♥ Q♦ A♠ J♦ | A♥ A♠       | 12           | Q♦ ?        | 10           | Enter action: |

  Scenario: bet twice in a row not finishing the round
    Given the round is started with the deck "2♥ 2♦ 3♥ 3♦ 4♥ 4♦ 5♥ 5♦"
    And the bet "1" has been already done
    When I bet "1"
    Then I should see "The betting has already been done."

  Scenario: not enough cards in the deck
    Given the round is started with the deck "2♥"
    When I bet "1"
    Then I should see "No cards left in the deck. Game over!"
