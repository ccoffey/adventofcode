class Two
  def part_1(file)
   horizontal = 0
   depth = 0
   data = load_input(file)
   data.each do |heading, power|
     case heading
     when 'forward'
       horizontal += power
     when 'down'
       depth += power
     when 'up'
       depth -= power
     end
   end
   horizontal * depth
  end

  def part_2(file)
    horizontal = 0
    depth = 0
    aim = 0
    data = load_input(file)
    data.each do |heading, power|
      case heading
      when 'forward'
        horizontal += power
        depth += (aim * power)
      when 'down'
        aim += power
      when 'up'
        aim -= power
      end
    end
    horizontal * depth
  end

  def load_input(file)
    File.readlines(file)
        .map { |line| line.strip.split(' ') }
        .map { |heading, power| [heading, power.to_i] }
  end
end
