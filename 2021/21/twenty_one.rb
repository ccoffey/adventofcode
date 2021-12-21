# frozen_string_literal: true

class TwentyOne

  def part_1(player_1_position:, player_2_position:)
    # Board positions 0..9 are much more convenient to work with than 1..10
    p1_pos = player_1_position == 1 ? 10 : player_1_position - 1
    p2_pos = player_2_position == 1 ? 10 : player_2_position - 1
    play_part_1(p1_pos: p1_pos, p1_score: 0, p2_pos: p2_pos, p2_score: 0, roll: 0)
  end

  def play_part_1(p1_pos:, p1_score:, p2_pos:, p2_score:, roll:)
    # Base cases
    return p2_score * roll if p1_score >= 1000
    return p1_score * roll if p2_score >= 1000

    # Player 1 moves
    new_p1_pos = (p1_pos + roll + 1 + roll + 2 + roll + 3) % 10
    new_p1_score = p1_score + new_p1_pos + 1

    # Player 2 goes next
    play_part_1(p1_pos: p2_pos, p1_score: p2_score, p2_pos: new_p1_pos, p2_score: new_p1_score, roll: roll + 3)
  end

  def part_2(player_1_position:, player_2_position:)
    # Board positions 0..9 are much more convenient to work with than 1..10
    p1_pos = player_1_position == 1 ? 10 : player_1_position - 1
    p2_pos = player_2_position == 1 ? 10 : player_2_position - 1
    play_part_2(p1_pos: p1_pos, p1_score: 0, p2_pos: p2_pos, p2_score: 0).max
  end

  def play_part_2(p1_pos:, p1_score:, p2_pos:, p2_score:, memo: {})
    # Memoize
    key = [p1_pos, p1_score, p2_pos, p2_score]
    return memo[key] if memo.key?(key)

    # Base cases
    return [1, 0] if p1_score >= 21
    return [0, 1] if p2_score >= 21

    # All possible sums of 3 dice throws
    all_possible_rolls = [1, 2, 3].repeated_permutation(3).map(&:sum)

    p1_wins = 0
    p2_wins = 0
    all_possible_rolls.each do |roll|
      # Player 1 moves
      new_p1_pos = (p1_pos + roll) % 10
      new_p1_score = p1_score + new_p1_pos + 1

      # Player 2 goes next
      new_p2_wins, new_p1_wins = play_part_2(
        p1_pos: p2_pos,
        p1_score: p2_score,
        p2_pos: new_p1_pos,
        p2_score: new_p1_score,
        memo: memo
      )

      p1_wins += new_p1_wins
      p2_wins += new_p2_wins
    end

    memo[key] = [p1_wins, p2_wins]
    memo[key]
  end

end
