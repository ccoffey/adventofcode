# frozen_string_literal: true

require_relative '../../../2021/22/twenty_two'

RSpec.describe TwentyTwo do
  describe 'part_1' do
    it 'works for the example' do
      reboot_steps = subject.load_input('2021/22/example.txt')
      expect(subject.part_1(reboot_steps)).to eq(39)
    end

    it 'works for the large example' do
      reboot_steps = subject.load_input('2021/22/large_example.txt')
      expect(subject.part_1(reboot_steps)).to eq(590784)
    end

    it 'works for the input' do
      reboot_steps = subject.load_input('2021/22/input.txt')
      expect(subject.part_1(reboot_steps)).to eq(567496)
    end
  end

  describe 'part_2' do
    it 'works for the very large example' do
      reboot_steps = subject.load_input('2021/22/very_large_example.txt')
      expect(subject.part_2(reboot_steps)).to eq(2758514936282235)
    end

    it 'works for the input' do
      reboot_steps = subject.load_input('2021/22/input.txt')
      expect(subject.part_2(reboot_steps)).to eq(1355961721298916)
    end
  end
end
