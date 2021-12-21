# frozen_string_literal: true

require_relative '../../../2021/20/twenty'

RSpec.describe Twenty do
  describe 'part_1' do
    it 'works for the example' do
      algorithm, image = subject.load_input('2021/20/example.txt')
      expect(subject.part_1(algorithm, image)).to eq(35)
    end

    it 'works for the input' do
      algorithm, image = subject.load_input('2021/20/input.txt')
      expect(subject.part_1(algorithm, image)).to eq(5231)
    end
  end

  describe 'part_2' do
    it 'works for the example' do
      algorithm, image = subject.load_input('2021/20/example.txt')
      expect(subject.part_2(algorithm, image)).to eq(3351)
    end

    it 'works for the input' do
      algorithm, image = subject.load_input('2021/20/input.txt')
      expect(subject.part_2(algorithm, image)).to eq(14279)
    end
  end

  describe 'pad' do
    it 'pads the image' do
      image = [
        ['#', '#', '#'],
        ['#', '.', '#'],
        ['#', '#', '#']
      ]
      expect(subject.pad(image: image, padding: 2, default: '$')).to match_array([
        ['$', '$', '$', '$', '$', '$', '$'],
        ['$', '$', '$', '$', '$', '$', '$'],
        ['$', '$', '#', '#', '#', '$', '$'],
        ['$', '$', '#', '.', '#', '$', '$'],
        ['$', '$', '#', '#', '#', '$', '$'],
        ['$', '$', '$', '$', '$', '$', '$'],
        ['$', '$', '$', '$', '$', '$', '$'],
      ])
    end
  end

  describe 'count_lit' do
    it 'works' do
      image = [
        ['#', '.', '.', '#', '.', '.', '#'],
        ['.', '#', '.', '#', '.', '#', '.'],
        ['.', '.', '#', '#', '#', '.', '.'],
        ['.', '.', '.', '#', '.', '.', '.'],
        ['.', '.', '#', '#', '#', '.', '.'],
        ['.', '#', '.', '#', '.', '#', '.'],
        ['#', '.', '.', '#', '.', '.', '#'],
      ]
      expect(subject.count_lit(image)).to eq(19)
    end
  end
end
