# frozen_string_literal: true

require_relative '../../../2021/2/two'

RSpec.describe Two do
  describe 'part_1' do
    it 'works for the example' do
      expect(subject.part_1('2021/2/example.txt')).to eq(150)
    end

    it 'works for the input' do
      expect(subject.part_1('2021/2/input.txt')).to eq(1692075)
    end
  end

  describe 'part_2' do
    it 'works for the example' do
      expect(subject.part_2('2021/2/example.txt')).to eq(900)
    end

    it 'works for the input' do
      expect(subject.part_2('2021/2/input.txt')).to eq(1749524700)
    end
  end
end
