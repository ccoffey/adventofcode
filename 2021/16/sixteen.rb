class Sixteen

  HEX_TO_BIN_DECODER = {
    '0' => '0000',
    '1' => '0001',
    '2' => '0010',
    '3' => '0011',
    '4' => '0100',
    '5' => '0101',
    '6' => '0110',
    '7' => '0111',
    '8' => '1000',
    '9' => '1001',
    'A' => '1010',
    'B' => '1011',
    'C' => '1100',
    'D' => '1101',
    'E' => '1110',
    'F' => '1111'
  }.freeze

  TOTAL_LENGTH_IN_BITS = 0
  NUM_SUB_PACKETS = 1

  SUM = 0
  PRODUCT = 1
  MINIMUM = 2
  MAXIMUM = 3
  LITERAL = 4
  GREATER_THAN = 5
  LESS_THAN = 6
  EQUAL = 7

  def problem_1(bits)
    sum_versions(parse(bits))
  end

  def problem_2(bits)
    walk_eval(parse(bits))
  end

  def sum_versions(node)
    node[:version] + node[:children].map { |child| sum_versions(child) }.sum
  end

  def parse(bits)
    version = read_int(bits, 3)
    type_id = read_int(bits, 3)

    case type_id
    when LITERAL
      { version: version, type_id: type_id, children: [], value: parse_literal(bits) }
    else
      { version: version, type_id: type_id, children: parse_operator_packet(bits) }
    end
  end

  def walk_eval(node)
    return node[:value] if node.key?(:value)

    case node[:type_id]
    when SUM
      node[:children].map { |child| walk_eval(child) }.inject(:+)
    when PRODUCT
      node[:children].map { |child| walk_eval(child) }.inject(:*)
    when MINIMUM
      node[:children].map { |child| walk_eval(child) }.min
    when MAXIMUM
      node[:children].map { |child| walk_eval(child) }.max
    when GREATER_THAN
      walk_eval(node[:children][0]) > walk_eval(node[:children][1]) ? 1 : 0
    when LESS_THAN
      walk_eval(node[:children][0]) < walk_eval(node[:children][1]) ? 1 : 0
    when EQUAL
      walk_eval(node[:children][0]) == walk_eval(node[:children][1]) ? 1 : 0
    end
  end

  def parse_operator_packet(bits)
    length_type_id = read_int(bits, 1)
    case length_type_id
    when TOTAL_LENGTH_IN_BITS
      total_length_in_bits = read_int(bits, 15)
      processed = 0
      subs = []
      while processed != total_length_in_bits
        before_size = bits.size
        subs << parse(bits)
        processed += before_size - bits.size
      end
      subs
    when NUM_SUB_PACKETS
      read_int(bits, 11).times.collect do
        parse(bits)
      end
    end
  end

  def parse_literal(bits)
    value_bits = []
    loop do
      stop = read_int(bits, 1).zero?
      value_bits << bits.slice!(0, 4)
      break if stop
    end
    value_bits.join.to_i(2)
  end

  def hex_to_bin(str)
    str.chars.map { |char| HEX_TO_BIN_DECODER[char] }.join.chars
  end

  def read_int(bits, n)
    bits.slice!(0, n).join.to_i(2)
  end

end
