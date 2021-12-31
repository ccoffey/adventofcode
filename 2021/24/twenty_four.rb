# frozen_string_literal: true

require 'set'

class TwentyFour

  class State
    attr_accessor :i, :x, :y, :z, :w

    def initialize(i:, x:, y:, z:, w:)
      @i = i # Digit index (0 => 13)

      # Internal ALU state
      @x = x
      @y = y
      @z = z
      @w = w
    end

    # Set: https://ruby-doc.org/stdlib-1.8.7/libdoc/set/rdoc/Set.html
    # The equality of each couple of elements is determined according to Object#eql? and Object#hash, since Set uses Hash as storage.
    def eql?(other)
      [
        i == other.i,
        x == other.x,
        y == other.y,
        z == other.z,
        w == other.w
      ].all?
    end

    def hash
      [i, x, y, z, w].hash
    end

    def to_s
      "State(i: #{i}, x: #{x}, y: #{y}, #{z}, #{w})"
    end
  end

  def evaluate(program:, x:, y:, z:, w:, inp:)
    registers = { 'x' => x, 'y' => y, 'z' => z, 'w' => w }

    program.each do |instruction|
      operator, a, b = instruction
      case operator
      when 'inp'
        registers[a] = inp
      when 'add'
        registers[a] += b.is_a?(Integer) ? b : registers[b]
      when 'mul'
        registers[a] *= b.is_a?(Integer) ? b : registers[b]
      when 'div'
        registers[a] /= b.is_a?(Integer) ? b : registers[b]
      when 'mod'
        registers[a] %= b.is_a?(Integer) ? b : registers[b]
      when 'eql'
        registers[a] = if b.is_a?(Integer)
          registers[a] == b ? 1 : 0
        else
          registers[a] == registers[b] ? 1 : 0
        end
      end
    end

    [registers['x'], registers['y'], registers['z'], registers['w']]
  end

  def load_programs(file)
    programs = []
    program = []

    File.open(file).each_line do |line|
      if line.start_with?('inp')
        programs << program unless program.empty?
        program = []
      else
        operator, a, b = line.strip.split(' ')
        program << [operator, a, %w[x y z w].include?(b) ? b : b.to_i]
      end
    end

    programs << program
  end

  def common_setup(file)
    @programs = load_programs(file)
    @visited = Set.new([])
    @index = 0
  end

  def part_1(file)
    common_setup(file)
    @reverse = true
    solve(
      state: State.new(i: 0, x: 0, y: 0, z: 0, w: 0),
      curr_num: 0
    )
  end

  def part_2(file)
    common_setup(file)
    @reverse = false
    solve(
      state: State.new(i: 0, x: 0, y: 0, z: 0, w: 0),
      curr_num: 0
    )
  end

  def solve(state:, curr_num:)
    # If we found a solution, then we should stop the recursion and bubble up the answer
    return if @found

    # Do not re-visit states
    return if @visited.include?(state)
    @visited.add(state)

    # It takes a long time ot find an answer, so print some progress
    @index += 1
    if @index % 100000 == 0
      puts "index: #{@index}, current: #{curr_num}, #{state}"
    end

    if state.i == 14
      # We found the solution
      if state.z.zero?
        @found = true
        return curr_num
      end

      # We found a dead end, we should not continue past the 14th digit
      return
    end

    # We want to try every possible input 1 => 9
    range = (1..9)

    # We want the largest (part_1) and smallest (part_2)
    range = range.reverse_each if @reverse

    # Try every possible value for this input
    range.map do |inp|
      new_x, new_y, new_z, new_w = evaluate(program: @programs[state.i], x: state.x, y: state.y, z: state.z, w: inp, inp: inp)
      solve(
        state: State.new(i: state.i + 1, x: new_x, y: new_y, z: new_z, w: new_w),
        curr_num: curr_num * 10 + inp
      )
    end.compact.first
  end

end
