# frozen_string_literal: true

require 'set'

class TwentyTwo

  class Cuboid
    attr_reader :x1, :x2, :y1, :y2, :z1, :z2

    def initialize(x1, x2, y1, y2, z1, z2)
      @x1 = x1
      @x2 = x2
      @y1 = y1
      @y2 = y2
      @z1 = z1
      @z2 = z2
    end

    def area
      (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
    end

    def intersects(other)
      !(other.x1 > x2 || other.x2 < x1 || other.y1 > y2 || other.y2 < y1 || other.z1 > z2 || other.z2 < z1)
    end

    def intersection(other)
      return nil unless intersects(other)

      Cuboid.new(
        [x1, other.x1].max,
        [x2, other.x2].min,
        [y1, other.y1].max,
        [y2, other.y2].min,
        [z1, other.z1].max,
        [z2, other.z2].min
      )
    end

    def ==(other)
      [
        x1.eql?(other.x1),
        x2.eql?(other.x2),
        y1.eql?(other.y1),
        y2.eql?(other.y2),
        z1.eql?(other.z1),
        z2.eql?(other.z2)
      ].all?
    end

    def to_s
      "Cubiod(xmin=#{x1}, xmax=#{x2}, ymin=#{y1}, ymax=#{y2}, zmin=#{z1}, zmax=#{z2})"
    end

    def remove_intersection(other)
      inters = intersection(other)
      return [self] if inters.nil?

      return [] if inters == self

      remove(inters)
    end

    def remove(other)
      parts = []

      # top
      new_z1 = other.z2 + 1
      if new_z1 <= z2
        parts << Cuboid.new(x1, x2, y1, y2, new_z1, z2)
        new_z1 -= 1
      else
        new_z1 = z2
      end

      # bottom
      new_z2 = other.z1 - 1
      if new_z2 >= z1
        parts << Cuboid.new(x1, x2, y1, y2, z1, new_z2)
        new_z2 += 1
      else
       new_z2 = z1
      end

      # right
      new_x1 = other.x2 + 1
      if new_x1 <= x2
        parts << Cuboid.new(new_x1, x2, y1, y2, new_z2, new_z1)
        new_x1 -= 1
      else
        new_x1 = x2
      end

      # left
      new_x2 = other.x1 - 1
      if new_x2 >= x1
        parts << Cuboid.new(x1, new_x2, y1, y2, new_z2, new_z1)
        new_x2 += 1
      else
       new_x2 = x1
      end

      # back
      new_y1 = other.y2 + 1
      if new_y1 <= y2
        parts << Cuboid.new(new_x2, new_x1, new_y1, y2, new_z2, new_z1)
      end

      # front
      new_y2 = other.y1 - 1
      if new_y2 >= y1
        parts << Cuboid.new(new_x2, new_x1, y1, new_y2, new_z2, new_z1)
      end

      parts
    end

  end

  def load_input(file)
    reboot_steps = []
    File.open(file).each_line do |line|
      switch, axis_ranges = line.split(' ')
      data = axis_ranges.split(',').flat_map do |axis_range|
        _, range = axis_range.split('=')
        r_start, r_end = range.split('..')
        [r_start.to_i, r_end.to_i]
      end
      reboot_steps << { on: switch == 'on', cube: Cuboid.new(*data) }
    end
    reboot_steps
  end

  def part_1(reboot_steps)

  end

  def part_2(reboot_steps)
    activated = []
    reboot_steps.each do |reboot_step|
      activate = reboot_step[:on]
      cube = reboot_step[:cube]
      new_activated = []
      activated.each do |current|
        new_cubes = current.remove_intersection(cube)
        new_cubes.each do |new_cube|
          new_activated << new_cube
        end
      end
      if activate
        new_activated << cube
      end
      activated = new_activated
    end
    activated.map(&:area).sum
  end

end
