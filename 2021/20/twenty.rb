# frozen_string_literal: true

class Twenty

  def part_1(algorithm, image)
    2.times do |step|
      image = enhance(image: image, algorithm: algorithm, step: step + 1)
    end
    count_lit(image)
  end

  def part_2(algorithm, image)
    50.times do |step|
      image = enhance(image: image, algorithm: algorithm, step: step + 1)
    end
    count_lit(image)
  end

  def enhance(image:, algorithm:, step:)
    default = '.'

    flip_flop = algorithm[0] == '#' && algorithm[-1] == '.'
    default = step.even? ? '#' : '.' if flip_flop

    image = pad(image: image, padding: 1, default: default)
    output = Array.new(image.size) { Array.new(image[0].size) }

    image.each_with_index do |_, y|
      image.each_with_index do |_, x|
        output[y][x] = algorithm[to_decimal(to_binary(three_by_three_data(image, y, x, default)))]
      end
    end

    output
  end

  def pad(image:, padding:, default:)
    output = Array.new(image.size + (padding * 2)) { Array.new(image[0].size + (padding * 2), default) }

    image.each_with_index do |_, x|
      image.each_with_index do |_, y|
        output[x + padding][y + padding] = image[x][y]
      end
    end

    output
  end

  def display(image)
    image.each do |row|
      puts row.join
    end
    puts
  end

  # Handles out of bounds and returns the default character instead
  def safe_get(image, y, x, default)
    return default if x.negative?
    return default if y.negative?
    return default if x > image[0].size - 1
    return default if y > image.size - 1

    image[y][x]
  end

  def three_by_three_data(image, y, x, default)
    [
      safe_get(image, y - 1, x - 1, default), safe_get(image, y - 1, x - 0, default), safe_get(image, y - 1, x + 1, default),
      safe_get(image, y - 0, x - 1, default), safe_get(image, y - 0, x - 0, default), safe_get(image, y - 0, x + 1, default),
      safe_get(image, y + 1, x - 1, default), safe_get(image, y + 1, x - 0, default), safe_get(image, y + 1, x + 1, default)
    ].join
  end

  def count_lit(image)
    count = 0
    image.each_with_index do |_, x|
      image.each_with_index do |_, y|
        count += 1 if image[y][x] == '#'
      end
    end
    count
  end

  def to_binary(code)
    code.chars
        .map { |c| c == '.' ? '0' : '1' }
        .join
  end

  def to_decimal(binary)
    binary.to_i(2)
  end

  def load_input(file)
    enhancement_algorithm = nil
    image = []
    File.open(file).each_line.with_index do |line, index|
      if index == 0
        enhancement_algorithm = line
      elsif index == 1
        next
      else
        image << line.strip.chars
      end
    end
    [enhancement_algorithm.strip, image]
  end
end
