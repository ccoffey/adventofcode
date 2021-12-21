# frozen_string_literal: true

require_relative '../../../2021/21/twenty_one'

RSpec.describe TwentyOne do
  describe 'part_1' do
    it 'works for the example' do
      expect(subject.part_1(player_1_position: 4, player_2_position: 8)).to eq(739785)
    end

    it 'works for the input' do
      expect(subject.part_1(player_1_position: 3, player_2_position: 4)).to eq(995904)
    end
  end

  describe 'part_2' do
    it 'works for the example' do
      expect(subject.part_2(player_1_position: 4, player_2_position: 8)).to eq(444356092776315)
    end

    it 'works for the input' do
      expect(subject.part_2(player_1_position: 3, player_2_position: 4)).to eq(193753136998081)
    end
  end
end
