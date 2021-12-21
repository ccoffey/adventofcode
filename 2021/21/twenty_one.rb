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

    if (roll % 2).zero? # Player 1's move
      new_p1_pos = (p1_pos + roll + 1 + roll + 2 + roll + 3) % 10
      new_p1_score = p1_score + new_p1_pos + 1

      play_part_1(p1_pos: new_p1_pos, p1_score: new_p1_score, p2_pos: p2_pos, p2_score: p2_score, roll: roll + 3)
    else # Player 2's move
      new_p2_pos = (p2_pos + roll + 1 + roll + 2 + roll + 3) % 10
      new_p2_score = p2_score + new_p2_pos + 1

      play_part_1(p1_pos: p1_pos, p1_score: p1_score, p2_pos: new_p2_pos, p2_score: new_p2_score, roll: roll + 3)
    end
  end

  def part_2(player_1_position:, player_2_position:)
    # Board positions 0..9 are much more convenient to work with than 1..10
    p1_pos = player_1_position == 1 ? 10 : player_1_position - 1
    p2_pos = player_2_position == 1 ? 10 : player_2_position - 1
    play_part_2(p1_pos: p1_pos, p1_score: 0, p2_pos: p2_pos, p2_score: 0, turn: 0).max
  end

  def play_part_2(p1_pos:, p1_score:, p2_pos:, p2_score:, turn:, memo: {})
    # Memoize
    key = [p1_pos, p1_score, p2_pos, p2_score, turn]
    return memo[key] if memo.key?(key)

    # Base cases
    return [1, 0] if p1_score >= 21
    return [0, 1] if p2_score >= 21

    # All possible sums of 3 dice throws
    all_possible_rolls = [1, 2, 3].repeated_permutation(3).map(&:sum)

    results = all_possible_rolls.map do |roll|
      if (turn % 2).zero? # Player 1's move
        new_p1_pos = (p1_pos + roll) % 10
        new_p1_score = p1_score + new_p1_pos + 1
        play_part_2(
          p1_pos: new_p1_pos,
          p1_score: new_p1_score,
          p2_pos: p2_pos,
          p2_score: p2_score,
          turn: turn + 1,
          memo: memo
        )
      else # Player 2's move
        new_p2_pos = (p2_pos + roll) % 10
        new_p2_score = p2_score + new_p2_pos + 1
        play_part_2(
          p1_pos: p1_pos,
          p1_score: p1_score,
          p2_pos: new_p2_pos,
          p2_score: new_p2_score,
          turn: turn + 1,
          memo: memo
        )
      end
    end

    p1_wins, p2_wins = results.reduce { |a, b| [a[0] + b[0], a[1] + b[1]] }
    memo[key] = [p1_wins, p2_wins]
    memo[key]
  end

end
