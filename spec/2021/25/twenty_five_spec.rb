# frozen_string_literal: true

require_relative '../../../2021/25/twenty_five'

RSpec.describe TwentyFive do
  it 'works for the example' do
    matrix = subject.load_input('2021/25/example.txt')
    expect(subject.solve(matrix)).to eq(58)
  end

  it 'works for the input' do
    matrix = subject.load_input('2021/25/input.txt')
    expect(subject.solve(matrix)).to eq(305)
  end
end
