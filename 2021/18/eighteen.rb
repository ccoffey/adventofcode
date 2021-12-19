class Eighteen
  class Node
    attr_accessor :value, :parent, :left, :right

    def initialize(value, left, right)
      @value = value
      @left = left
      @right = right
    end

    def +(other)
      # We don't want the inputs (self & other) to be mutated by this operation
      # so we create deep copies of them and mutate these instead.
      # This bit me hard for part_2 because: [a + b] != [a + b] if the first + mutates a and b
      a = Marshal.load(Marshal.dump(self))
      b = Marshal.load(Marshal.dump(other))

      Node.new(nil, a, b).tap do |c|
        a.parent = c
        b.parent = c
        loop do
          again = c.reduce
          break unless again
        end
      end
    end

    def reduce
      needs_explosion = Eighteen.find_node_to_explode(self)
      if needs_explosion
        needs_explosion.explode
        return true
      end

      needs_split = Eighteen.find_node_to_split(self)
      needs_split&.split
      needs_split
    end

    def find_left_node
      current = self
      loop do
        return if current.parent.nil?

        if current != current.parent.left
          current = current.parent.left
          break
        else
          current = current.parent
        end
      end

      current = current.right until current.right.nil?
      current
    end

    def find_right_node
      current = self
      loop do
        return if current.parent.nil?

        if current != current.parent.right
          current = current.parent.right
          break
        else
          current = current.parent
        end
      end

      current = current.left until current.left.nil?
      current
    end

    def explode
      x = find_left_node
      x.value += left.value unless x.nil?

      y = find_right_node
      y.value += right.value unless y.nil?

      left.parent = nil
      right.parent = nil

      self.left = nil
      self.right = nil
      self.value = 0
    end

    def split
      new_left = Node.new((value / 2.0).floor, nil, nil)
      new_left.parent = self
      self.left = new_left

      new_right = Node.new((value / 2.0).ceil, nil, nil)
      new_right.parent = self
      self.right = new_right

      self.value = nil
    end

    def depth
      depth = 0
      current = self
      until current.parent.nil?
        current = current.parent
        depth += 1
      end
      depth
    end

    def stringify(node)
      return node.value.to_s if node.value

      "[#{stringify(node.left)},#{stringify(node.right)}]"
    end

    def to_s
      stringify(self)
    end
  end

  def self.build_tree(value)
    return Node.new(value, nil, nil) if value.is_a?(Integer)

    left = build_tree(value[0])
    right = build_tree(value[1])
    Node.new(nil, left, right).tap do |node|
      left.parent = node
      right.parent = node
    end
  end

  def self.find_node_to_explode(node)
    return false if node.nil?
    return node if node.depth == 4 && node.value.nil?

    find_node_to_explode(node.left) || find_node_to_explode(node.right)
  end

  def self.find_node_to_split(node)
    return nil if node.nil?
    return node if node.value && node.value >= 10

    find_node_to_split(node.left) || find_node_to_split(node.right)
  end

  def self.magnitude(node)
    return node.value if node.value

    (3 * magnitude(node.left)) + (2 * magnitude(node.right))
  end

  def self.part_1
    File.readlines('2021/18/input.txt')
        .map { |line| JSON.parse(line) }
        .map { |n| build_tree(n) }
        .reduce(:+)
  end

  def self.part_2
    list = File.readlines('2021/18/input.txt')
               .map { |line| JSON.parse(line) }
               .map { |array| build_tree(array) }

    indices = (0...list.size).to_a
    indices.product(indices)
           .reject { |i, j| i == j }
           .map { |i, j| Eighteen.magnitude(list[i] + list[j]) }
           .max
  end
end
