# frozen_string_literal: true

require_relative '../../../2021/23/twenty_three'

RSpec.describe TwentyThree::State do
  describe 'to_s' do
    it 'works with an empty hall' do
      state = described_class.new(Array.new(11, nil), [%w[B A], %w[C D], %w[B C], %w[D A]])
      expect(state.to_s).to eq('State(hall=[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], rooms=[["B", "A"], ["C", "D"], ["B", "C"], ["D", "A"]])')
    end

    it 'works with a non empty hall' do
      state = described_class.new([nil, nil, nil, 'B', nil, nil, nil, nil, nil, nil, nil], [%w[B A], %w[C D], [nil, 'C'], %w[D A]])
      expect(state.to_s).to eq('State(hall=[nil, nil, nil, "B", nil, nil, nil, nil, nil, nil, nil], rooms=[["B", "A"], ["C", "D"], [nil, "C"], ["D", "A"]])')
    end
  end

  describe 'end_state?' do
    let(:desired_rooms) { [%w[A A], %w[B B], %w[C C], %w[D D]] }
    it 'works' do
      expect(described_class.new(Array.new(11, nil), [%w[A A], %w[B B], %w[C C], %w[D D]]).end_state?(desired_rooms)).to eq(true)
      expect(described_class.new(Array.new(11, nil), [%w[A B], %w[C D], %w[A B], %w[C D]]).end_state?(desired_rooms)).to eq(false)
      expect(described_class.new(Array.new(11, nil), [%w[A A], %w[C C], %w[B B], %w[D D]]).end_state?(desired_rooms)).to eq(false)
    end
  end

  describe 'path_to_home_clear?' do
    it 'works for right paths' do
      hall = ['B', nil, nil, nil, nil, nil, 'D', 'A', nil, nil, nil]
      rooms = [[nil, 'A'], [nil, 'B'], %w[C C], [nil, 'D']]
      expect(described_class.new(hall, rooms).path_to_home_clear?(0)).to eq(true)
      expect(described_class.new(hall, rooms).path_to_home_clear?(7)).to eq(false)
    end

    it 'works for left paths' do
      hall = [nil, nil, nil, nil, 'D', 'A', nil, nil, nil, nil, 'C']
      rooms = [[nil, 'A'], ['B', 'B'], [nil, 'C'], [nil, 'D']]
      expect(described_class.new(hall, rooms).path_to_home_clear?(10)).to eq(true)
      expect(described_class.new(hall, rooms).path_to_home_clear?(5)).to eq(false)
    end
  end

  describe 'move_home' do
    it 'works when the room is completely full' do
      hall = ['B', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [[nil, 'B'], %w[A A], %w[C C], %w[D D]]
      expect(described_class.new(hall, rooms).move_home(0)).to eq(nil)
    end

    it 'works when the room is completely empty' do
      hall = ['B', nil, nil, nil, nil, nil, nil, nil, nil, nil, 'B']
      rooms = [%w[A A], [nil, nil], %w[C C], %w[D D]]
      expect(described_class.new(hall, rooms).move_home(0)).to match_array([
        60,
        described_class.new(
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'B'],
          [%w[A A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
    end

    it 'works when the room contains another Amphipod of the same type' do
      hall = ['B', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [%w[A A], [nil, 'B'], %w[C C], %w[D D]]
      expect(described_class.new(hall, rooms).move_home(0)).to match_array([
        50,
        described_class.new(
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
          [%w[A A], %w[B B], %w[C C], %w[D D]]
        )
      ])
    end
  end

  describe 'moves_from_room' do
    it 'works for an empty room' do
      hall = ['B', 'B', nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [%w[A A], [nil, nil], %w[C C], %w[D D]]
      expect(described_class.new(hall, rooms).moves_from_room(1)).to eq([])
    end

    it 'works for a room with 1 correct Amphipod' do
      hall = ['B', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [%w[A A], [nil, 'B'], %w[C C], %w[D D]]
      expect(described_class.new(hall, rooms).moves_from_room(1)).to eq([])
    end

    it 'works for a room with 2 correct Amphipods' do
      hall = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [%w[A A], %w[B B], %w[C C], %w[D D]]
      expect(described_class.new(hall, rooms).moves_from_room(1)).to eq([])
    end

    it 'works for a room with 2 Amphipod and no paths blocked' do
      hall = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [%w[B A], %w[A B], %w[C C], %w[D D]]

      moves = described_class.new(hall, rooms).moves_from_room(1)
      expect(moves.size).to eq(7)
      expect(moves[0]).to match_array([
        5,
        described_class.new(
          ['A', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
          [%w[B A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
      expect(moves[1]).to match_array([
        4,
        described_class.new(
          [nil, 'A', nil, nil, nil, nil, nil, nil, nil, nil, nil],
          [%w[B A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
      expect(moves[2]).to match_array([
        2,
        described_class.new(
          [nil, nil, nil, 'A', nil, nil, nil, nil, nil, nil, nil],
          [%w[B A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
      expect(moves[3]).to match_array([
        2,
        described_class.new(
          [nil, nil, nil, nil, nil, 'A', nil, nil, nil, nil, nil],
          [%w[B A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
      expect(moves[4]).to match_array([
        4,
        described_class.new(
          [nil, nil, nil, nil, nil, nil, nil, "A", nil, nil, nil],
          [%w[B A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
      expect(moves[5]).to match_array([
        6,
        described_class.new(
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, "A", nil],
          [%w[B A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
      expect(moves[6]).to match_array([
        7,
        described_class.new(
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'A'],
          [%w[B A], [nil, 'B'], %w[C C], %w[D D]]
        )
      ])
    end
  end

  describe 'move_from_hallway' do
    it 'works for an empty hallway' do
      hall = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [%w[A A], %w[B B], %w[C C], %w[D D]]
      expect(described_class.new(hall, rooms).move_from_hallway(0)).to eq(nil)
    end

    it 'works when the front of the room is empty' do
      hall = ['C', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [%w[A A], %w[B B], [nil, 'C'], %w[D D]]
      expect(described_class.new(hall, rooms).move_from_hallway(0)).to match_array([
        700,
        described_class.new(
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
          [%w[A A], %w[B B], %w[C C], %w[D D]]
        )
      ])
    end

    it 'works with the entire room is empty' do
      hall = ['C', nil, nil, nil, nil, nil, nil, nil, nil, nil, 'C']
      rooms = [%w[A A], %w[B B], [nil, nil], %w[D D]]
      expect(described_class.new(hall, rooms).move_from_hallway(0)).to match_array([
        800,
        described_class.new(
          [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'C'],
          [%w[A A], %w[B B], [nil, 'C'], %w[D D]]
        )
      ])
    end

    it 'works when there are no paths' do
      hall = ['C', 'A', nil, nil, nil, nil, nil, nil, nil, nil, nil]
      rooms = [[nil, 'A'], %w[B B], [nil, 'C'], %w[D D]]
      expect(described_class.new(hall, rooms).move_from_hallway(0)).to eq(nil)
    end
  end
end

RSpec.describe TwentyThree do
  describe 'part_1' do
    it 'works for the example' do
      hall, rooms = described_class.load_input('2021/23/example.txt')
      expect(described_class.part_1(hall: hall, rooms: rooms)).to eq(12521)
    end

    it 'works for the input' do
      hall, rooms = described_class.load_input('2021/23/input.txt')
      expect(described_class.part_1(hall: hall, rooms: rooms)).to eq(13455)
    end
  end

  describe 'part_2' do
    it 'works for the example' do
      hall, rooms = described_class.load_input('2021/23/example_2.txt')
      expect(described_class.part_2(hall: hall, rooms: rooms)).to eq(44169)
    end

    it 'works for the input' do
      hall, rooms = described_class.load_input('2021/23/input_2.txt')
      expect(described_class.part_2(hall: hall, rooms: rooms)).to eq(43567)
    end
  end
end
