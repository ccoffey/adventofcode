# frozen_string_literal: true

require_relative '../../../2021/24/twenty_four'

RSpec.describe TwentyFour do

  describe 'part_1' do
    it 'works for the input' do
      expect { subject.part_1('2021/24/input.txt') }.to raise_error("Solution: 59692994994998")
    end
  end

  describe 'part_2' do
    it 'works for the input' do
      expect(subject.part_2('2021/24/input.txt')).to eq(16181111641521)
    end
  end

end
