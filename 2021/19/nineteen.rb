# frozen_string_literal: true

require 'set'

class Nineteen

  def compute(scanners)
    # All locations are relative to scanner_0 at (0, 0)
    scanner_locations = { 0 => [0, 0, 0] }
    beacon_locations = Set.new(scanners.shift)

    # Loop until we find all the scanners
    while scanner_locations.keys.size < scanners.size + 1
      scanners.each_with_index do |scanner_data, scanner_index|
        # In the worst case, we will only find 1 new scanner per iteration.
        # We should skip scanners that we have already found on each loop.
        scanner_found = scanner_locations.key?(scanner_index + 1)
        next if scanner_found

        # In total, each scanner could be in any of 24 different orientations: facing positive or negative x, y, or z,
        # and considering any of four directions "up" from that facing.
        orientations.each do |orientation|
          # If we found the scanner using the previous orientation, then we should not continue trying orientations.
          break if scanner_found

          # We should re-orientate the data based on the current orientation assumption
          reoriented_data = apply_orientation(scanner_data, orientation)

          # We don't know the (x, y, z) offset of this scanner relative to scanner_0.
          # We could check every possible offset in some huge range:
          #   x_offset = -99999...99999
          #   y_offset = -99999...99999
          #   z_offset = -99999...99999
          # But this would be really slow.
          # Instead we check every pair of points formed by taking a beacon location from this scanners data
          # and comparing it to each already known beacon_location.
          # The way I like to visualise this is: imagine you had two sheets of transparent paper.
          # The first sheet contains dots for all the known beacon locations relative to scanner_0
          # The second sheet contains dots for all the beacon locations relative to the scanner that took these readings
          # We place the second sheet over the first and try to align 12 dots.
          # The procedure for this is:
          #  - assume dot_0 in sheet_1 is dot_0 in sheet_2 (see how many dots align)
          #  - assume dot_0 in sheet_1 is dot_1 in sheet_2 (see how many dots align)
          #  - assume dot_0 in sheet_1 is dot_2 in sheet_2 (see how many dots align)
          #  .
          #  .
          #  .
          #  - assume dot_1 in sheet_1 is dot_0 in sheet_2 (see how many dots align)
          #  - assume dot_1 in sheet_1 is dot_1 in sheet_2 (see how many dots align)
          #  - assume dot_1 in sheet_1 is dot_2 in sheet_2 (see how many dots align)
          # Stop if you find an overlap, now you know the (x, y, z) offsets of this scanner relative to scanner_0.
          reoriented_data.product(beacon_locations.to_a).each do |pair|
            x_offset = pair[1][0] - pair[0][0]
            y_offset = pair[1][1] - pair[0][1]
            z_offset = pair[1][2] - pair[0][2]

            # If there was no overlap, then we should check the next set of offsets.
            next unless overlap?(beacon_locations, scanner_data, [x_offset, y_offset, z_offset], orientation)

            # If there was an overlap, then we now know the location of this scanner relative to scanner_0.
            scanner_locations[scanner_index + 1] = [x_offset, y_offset, z_offset]

            # Now that we have the offsets, we can compute the position of each beacon relative to scanner_0.
            scanner_data.each do |beacon|
              beacon_locations.add([
                (beacon[orientation[0][0]] * orientation[0][1]) + x_offset,
                (beacon[orientation[1][0]] * orientation[1][1]) + y_offset,
                (beacon[orientation[2][0]] * orientation[2][1]) + z_offset
              ])
            end

            # We are pretty deeply nested, we need a signal for higher up loops to break
            scanner_found = true
            break
          end
        end
      end
    end

    [scanner_locations, beacon_locations]
  end

  def part_1(scanners)
    _, beacon_locations = compute(scanners)
    beacon_locations.count
  end

  def part_2(scanners)
    scanner_locations, = compute(scanners)
    scanner_locations.values.product(scanner_locations.values)
                     .reject { |a, b| a == b }
                     .map { |a, b| manhattan_distance(a, b) }
                     .max
  end

  def manhattan_distance(a, b)
    a.zip(b)
     .map { |c, d| (c - d).abs }
     .sum
  end

  def apply_orientation(scanner_data, orientation)
    scanner_data.map do |beacon|
      [
        beacon[orientation[0][0]] * orientation[0][1],
        beacon[orientation[1][0]] * orientation[1][1],
        beacon[orientation[2][0]] * orientation[2][1]
      ]
    end
  end

  def overlap?(beacon_locations, scanner_data, offsets, orientation)
    overlap = 0
    scanner_data.each do |beacon|
      overlap += 1 if beacon_locations.include?([
        beacon[orientation[0][0]] * orientation[0][1] + offsets[0],
        beacon[orientation[1][0]] * orientation[1][1] + offsets[1],
        beacon[orientation[2][0]] * orientation[2][1] + offsets[2]
      ])

      # There might be more, but this is enough to consider this an overlap
      return true if overlap == 12
    end

    false
  end

  def load_input(file)
    scanners = []
    current = []
    File.open(file).each_line do |line|
      if line.start_with?('---')
        current = []
      elsif line.strip == ''
        scanners << current
      else
        current << line.strip.split(',').map(&:to_i)
      end
    end
    scanners << current
  end

  # According to the problem statement there are only 24 orientations we need to check
  # My code computes 48, so half of these must be redundant somehow but I don't understand how.
  def orientations
    Enumerator.new do |yielder|
      [0, 1, 2].permutation do |axis_permutation|
        [1, -1].each do |a_direction|
          [1, -1].each do |b_direction|
            [1, -1].each do |c_direction|
              yielder << [
                [axis_permutation[0], a_direction],
                [axis_permutation[1], b_direction],
                [axis_permutation[2], c_direction]
              ]
            end
          end
        end
      end
    end
  end

end
