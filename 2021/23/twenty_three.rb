# frozen_string_literal: true

require 'set'
require 'pqueue'

module TwentyThree

  EMPTY_HALL = Array.new(11, nil)
  HOME_X = { 'A' => 2, 'B' => 4, 'C' => 6, 'D' => 8 }.freeze
  ROOM_ID = { 'A' => 0, 'B' => 1, 'C' => 2, 'D' => 3 }.freeze
  COST = { 'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000 }.freeze

  class State
    attr_accessor :hall, :rooms

    def initialize(hall, rooms)
      @hall = hall
      @rooms = rooms
    end

    def end_state?(desired_rooms)
      hall.eql?(EMPTY_HALL) && rooms.eql?(desired_rooms)
    end

    def path_to_home_clear?(position)
      amphipod = hall[position]
      a, b = [position, HOME_X[amphipod]].minmax
      ((a + 1)...b).each do |step|
        return false unless hall[step].nil?
      end

      true
    end

    def move_home(position)
      amphipod = hall[position]
      home_room = ROOM_ID[amphipod]

      # The cost to get to the entrance of the room
      cost = (HOME_X[amphipod] - position).abs * COST[amphipod]

      # The room is completely empty
      if rooms[home_room].all?(&:nil?)
        new_hall = hall.clone
        new_hall[position] = nil

        new_rooms = rooms.map(&:clone)
        new_rooms[home_room][rooms[0].size - 1] = amphipod # It is always optimal to move to the back of the room if you can

        return [cost + (COST[amphipod] * rooms[0].size), State.new(new_hall, new_rooms)]
      end

      # The room only contains other Amphipods of the same type
      if rooms[home_room].all? { |other| other.nil? || other == amphipod }
        new_hall = hall.clone
        new_hall[position] = nil

        new_rooms = rooms.map(&:clone)
        index = new_rooms[home_room].find_index(&:nil?)
        new_rooms[home_room][index] = amphipod

        return [cost + (COST[amphipod] * (index + 1)), State.new(new_hall, new_rooms)]
      end

      nil
    end

    def move_from_hallway(position)
      # If there is no amphipod at this position, then there are no moves from this position.
      return nil if hall[position].nil?

      # If there is an Amphipod on the path home, then there are no moves from this position.
      return nil unless path_to_home_clear?(position)

      # There is a move home if:
      # - Home is empty or only contains Amphipods of the same type
      # - There is a path home
      move_home(position)
    end

    def moves_from_room(room_id)
      # If the room is empty, then there are no moves from this room.
      return [] if rooms[room_id].all?(&:nil?)

      # If the room only contains Amphipods of the correct type, then we should do nothing.
      return [] if rooms[room_id].all? { |amphipod| amphipod.nil? || amphipod == ROOM_ID.key(room_id) }

      # Find the Amphipod that should move, it will be the closest on to the door.
      index = rooms[room_id].find_index { |amphipod| !amphipod.nil? }
      amphipod = rooms[room_id][index]

      moves = []
      room_x = HOME_X[ROOM_ID.key(room_id)]

      # Each hallway position is a valid destination for this Amphipod
      (0...hall.size).each do |destination|
        # You cannot stop in a doorway
        next if HOME_X.values.include?(destination)

        # You can only move to a destination if the path is clear
        a, b = [room_x, destination].minmax
        path = hall[a..b]
        next unless path.compact.empty?

        new_hall = hall.clone
        new_hall[destination] = amphipod

        new_room = rooms.map(&:clone)
        new_room[room_id][index] = nil

        moves << [COST[amphipod] * (index + path.size), State.new(new_hall, new_room)]
      end

      moves
    end

    def all_possible_moves
      moves = []

      # For all Amphipods in the hallway
      (0...hall.size).each do |position|
        move = move_from_hallway(position)
        moves << move unless move.nil?
      end

      # For all Amphipods in rooms
      (0...rooms.size).each do |room_number|
        moves += moves_from_room(room_number)
      end

      moves
    end

    def ==(other)
      eql?(other)
    end

    def eql?(other)
      hall.eql?(other.hall) && rooms.eql?(other.rooms)
    end

    def hash
      [hall, rooms].hash
    end

    def to_s
      "State(hall=#{hall}, rooms=#{rooms})"
    end
  end

  def self.load_input(file)
    f = File.open(file)

    # Pointless line, throw it away
    f.readline

    hall = f.readline.strip[1..-2].chars
    hall = hall.map { |v| v == '.' ? nil : v }

    i = 0
    rooms = []
    loop do
      break if f.eof?

      amphipods = f.readline.strip.chars.delete_if { |c| c == '#' }
      if i.zero?
        rooms = amphipods.map { [] }
        i += 1
      end
      amphipods.each_with_index do |amphipod, index|
        rooms[index] << amphipod
      end
    end

    [hall, rooms]
  end

  def self.play(hall:, rooms:, desired_rooms:)
    start = State.new(hall, rooms)
    visited = Set.new([])
    queue = PQueue.new([[0, start, []]]) { |a, b| a[0] < b[0] }
    min_cost = Float::INFINITY

    until queue.empty?
      cost, state = *queue.pop

      # Do not visit states that we have already visited
      next if visited.include?(state)

      visited.add(state)

      # Do not visit states with a higher cost than the best solution found so far
      next if cost > min_cost

      # Keep track of the best solution found so far
      min_cost = [cost, min_cost].min if state.end_state?(desired_rooms)

      # Evaluate every possible move
      state.all_possible_moves.each do |move_cost, new_state|
        queue.push([cost + move_cost, new_state])
      end
    end

    min_cost
  end

  def self.part_1(hall:, rooms:)
    desired_rooms = [%w[A A], %w[B B], %w[C C], %w[D D]]
    play(hall: hall, rooms: rooms, desired_rooms: desired_rooms)
  end

  def self.part_2(hall:, rooms:)
    desired_rooms = [%w[A A A A], %w[B B B B], %w[C C C C], %w[D D D D]]
    play(hall: hall, rooms: rooms, desired_rooms: desired_rooms)
  end
end
