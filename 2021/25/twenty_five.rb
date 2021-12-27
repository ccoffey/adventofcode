# frozen_string_literal: true

class TwentyFive

  def display(matrix)
    matrix.each do |row|
      puts row.join
    end
    puts
  end

  def load_input(file)
    matrix = []
    File.open(file).each_line do |line|
      matrix << line.strip.chars
    end
    matrix
  end

  def step(matrix)
    new_matrix = Array.new(matrix.size) { Array.new(matrix[0].size, '.') }
    mod_y = matrix.size
    mod_x = matrix[0].size

    # east-facing herd moves
    matrix.each_with_index do |row, y|
      row.each_with_index do |_, x|
        if matrix[y][x] == '>' && matrix[y][(x + 1) % mod_x] == '.'
          new_matrix[y][x] = '.'
          new_matrix[y][(x + 1) % mod_x] = '>'
        else
          new_matrix[y][x] = matrix[y][x] if new_matrix[y][x] != '>'
        end
      end
    end

    matrix = new_matrix
    new_matrix = Array.new(matrix.size) { Array.new(matrix[0].size, '.') }

    # south-facing herd moves
    matrix.each_with_index do |row, y|
      row.each_with_index do |_, x|
        if matrix[y][x] == 'v' && matrix[(y + 1) % mod_y][x] == '.'
          new_matrix[y][x] = '.'
          new_matrix[(y + 1) % mod_y][x] = 'v'
        else
          new_matrix[y][x] = matrix[y][x] if new_matrix[y][x] != 'v'
        end
      end
    end

    new_matrix
  end

  def solve(matrix)
    puts('Initial state:')
    display(matrix)

    i = 1
    loop do
      puts("After #{i} step:")
      new_matrix = step(matrix)
      return i if matrix == new_matrix

      matrix = new_matrix
      display(matrix)
      i += 1
    end
  end

end
