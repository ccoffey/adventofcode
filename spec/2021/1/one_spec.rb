# frozen_string_literal: true

require_relative '../../../2021/1/one'

RSpec.describe One do
  describe 'part_1' do
    it 'works for the example' do
      expect(subject.part_1('2021/1/example.txt')).to eq(7)
    end

    it 'works for the input' do
      expect(subject.part_1('2021/1/input.txt')).to eq(1832)
    end
  end

  describe 'part_2' do
    it 'works for the example' do
      expect(subject.part_2('2021/1/example.txt')).to eq(5)
    end

    it 'works for the input' do
      expect(subject.part_2('2021/1/input.txt')).to eq(1858)
    end
  end
end
