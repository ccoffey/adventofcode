class One
  def part_1(file)
    solve(array: load_input(file), n: 1)
  end

  def part_2(file)
    solve(array: load_input(file), n: 3)
  end

  def load_input(file)
    File.readlines(file).map(&:to_i)
  end

  def solve(array:, n:)
    array.each_cons(n)
         .map(&:sum)
         .each_cons(2)
         .map { |a, b| a < b ? 1 : 0 }
         .sum
  end
end
