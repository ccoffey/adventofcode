# frozen_string_literal: true

require_relative '../../../2021/16/sixteen'

RSpec.describe Sixteen do
  context '#problem_1' do
    it 'works for 8A004A801A8002F478' do
      expect(subject.parse(subject.hex_to_bin('8A004A801A8002F478'))).to eq({
        version: 4,
        type_id: 2,
        children: [{
          version: 1,
          type_id: 2,
          children: [{
            version: 5,
            type_id: 2,
            children: [{
              version: 6,
              type_id: 4,
              value: 15,
              children: []
            }]
          }]
        }]
      })
    end

    it 'works for 620080001611562C8802118E34' do
      expect(subject.parse(subject.hex_to_bin('620080001611562C8802118E34'))).to eq({
        version: 3,
        type_id: 0,
        children: [
          {
            version: 0,
            type_id: 0,
            children: [
              { version: 0, type_id: 4, value: 10, children: [] },
              { version: 5, type_id: 4, value: 11, children: [] }
            ]
          },
          {
            version: 1,
            type_id: 0,
            children: [
              { version: 0, type_id: 4, value: 12, children: [] },
              { version: 3, type_id: 4, value: 13, children: [] }
            ]
          }
        ]
      })
    end

    it 'works for C0015000016115A2E0802F182340' do
      expect(subject.parse(subject.hex_to_bin('C0015000016115A2E0802F182340'))).to eq({
        version: 6,
        type_id: 0,
        children: [
          {
            version: 0,
            type_id: 0,
            children: [
              { version: 0, type_id: 4, value: 10, children: [] },
              { version: 6, type_id: 4, value: 11, children: [] }
            ]
          },
          {
            version: 4,
            type_id: 0,
            children: [
              { version: 7, type_id: 4, value: 12, children: [] },
              { version: 0, type_id: 4, value: 13, children: [] }
            ]
          }
        ]
      })
    end

    it 'works for A0016C880162017C3686B18A3D4780' do
      expect(subject.parse(subject.hex_to_bin('A0016C880162017C3686B18A3D4780'))).to eq({
        version: 5,
        type_id: 0,
        children: [{
          version: 1,
          type_id: 0,
          children: [{
            version: 3,
            type_id: 0,
            children: [
              { version: 7, type_id: 4, value: 6, children: [] },
              { version: 6, type_id: 4, value: 6, children: [] },
              { version: 5, type_id: 4, value: 12, children: [] },
              { version: 2, type_id: 4, value: 15, children: [] },
              { version: 2, type_id: 4, value: 15, children: [] }
            ]
          }]
        }]
      })
    end

    it 'works for the input' do
      expect(subject.problem_1(subject.hex_to_bin(File.read('2021/16/input.txt')))).to eq(949)
    end
  end

  context '#problem_2' do
    it 'works for sum(1,2)' do
      expect(subject.problem_2(subject.hex_to_bin('C200B40A82'))).to eq(3)
    end

    it 'works for product(6,9)' do
      expect(subject.problem_2(subject.hex_to_bin('04005AC33890'))).to eq(54)
    end

    it 'works for minimum(7,8,9)' do
      expect(subject.problem_2(subject.hex_to_bin('880086C3E88112'))).to eq(7)
    end

    it 'works for maximum(7,8,9)' do
      expect(subject.problem_2(subject.hex_to_bin('CE00C43D881120'))).to eq(9)
    end

    it 'works for 5<15' do
      expect(subject.problem_2(subject.hex_to_bin('D8005AC2A8F0'))).to eq(1)
    end

    it 'works for 5>15' do
      expect(subject.problem_2(subject.hex_to_bin('F600BC2D8F'))).to eq(0)
    end

    it 'works for 5==15' do
      expect(subject.problem_2(subject.hex_to_bin('9C005AC2F8F0'))).to eq(0)
    end

    it 'works for sum(1,3) == prod(2,2)' do
      expect(subject.problem_2(subject.hex_to_bin('9C0141080250320F1802104A08'))).to be(1)
    end

    it 'works for the input' do
      expect(subject.problem_2(subject.hex_to_bin(File.read('2021/16/input.txt')))).to eq(1_114_600_142_730)
    end
  end
end
