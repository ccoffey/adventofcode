# frozen_string_literal: true

require_relative '../../../2021/19/nineteen'

RSpec.describe Nineteen do
  context 'example' do
    context 'part_1' do
      it 'works' do
        scanner_data = subject.load_input('2021/19/example.txt')
        expect(subject.part_1(scanner_data)).to eq(79)
      end
    end

    context 'part_2' do
      it 'works' do
        scanner_data = subject.load_input('2021/19/example.txt')
        expect(subject.part_2(scanner_data)).to eq(3621)
      end
    end
  end

  context 'input' do
    context 'part_1' do
      it 'works' do
        scanner_data = subject.load_input('2021/19/input.txt')
        expect(subject.part_1(scanner_data)).to eq(318)
      end
    end

    context 'part_2' do
      it 'works' do
        scanner_data = subject.load_input('2021/19/input.txt')
        expect(subject.part_2(scanner_data)).to eq(12166)
      end
    end
  end
end
