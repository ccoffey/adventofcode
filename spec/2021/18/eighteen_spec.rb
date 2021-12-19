# frozen_string_literal: true

require_relative '../../../2021/18/eighteen'
require 'json'

RSpec.describe Eighteen do

  describe 'explode' do
    it '[[[[[9,8],1],2],3],4] becomes [[[[0,9],2],3],4]' do
      tree = described_class.build_tree([[[[[9, 8], 1], 2], 3], 4])
      tree.left.left.left.left.explode
      expect(tree.to_s).to eq('[[[[0,9],2],3],4]')
    end

    it '[7,[6,[5,[4,[3,2]]]]] becomes [7,[6,[5,[7,0]]]]' do
      tree = described_class.build_tree([7, [6, [5, [4, [3, 2]]]]])
      tree.right.right.right.right.explode
      expect(tree.to_s).to eq('[7,[6,[5,[7,0]]]]')
    end

    it '[[6,[5,[4,[3,2]]]],1] becomes [[6,[5,[7,0]]],3]' do
       tree = described_class.build_tree([[6, [5, [4, [3, 2]]]], 1])
       tree.left.right.right.right.explode
       expect(tree.to_s).to eq('[[6,[5,[7,0]]],3]')
    end

    it '[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]' do
      tree = described_class.build_tree([[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]])
      tree.left.right.right.right.explode
      expect(tree.to_s).to eq('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]')
    end

    it '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[7,0]]]]' do
      tree = described_class.build_tree([[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]])
      tree.right.right.right.right.explode
      expect(tree.to_s).to eq('[[3,[2,[8,0]]],[9,[5,[7,0]]]]')
    end
  end

  describe 'split' do
    it '[10,0] becomes [[5,5],1]' do
       tree = described_class.build_tree([10, 0])
       tree.left.split
       expect(tree.to_s).to eq('[[5,5],0]')
    end

    it '[11,0] becomes [[5,6],0]' do
       tree = described_class.build_tree([11, 0])
       tree.left.split
       expect(tree.to_s).to eq('[[5,6],0]')
    end

    it '[12,0] becomes [[6,6],0]' do
       tree = described_class.build_tree([12, 0])
       tree.left.split
       expect(tree.to_s).to eq('[[6,6],0]')
    end
  end

  describe 'reduce' do
    it 'works' do
      c = described_class.build_tree([[[[[4, 3], 4], 4], [7, [[8, 4], 9]]], [1, 1]])

      # after explode
      expect(c.reduce).to be_truthy
      expect(c.to_s).to eq('[[[[0,7],4],[7,[[8,4],9]]],[1,1]]')

      # after explode
      expect(c.reduce).to be_truthy
      expect(c.to_s).to eq('[[[[0,7],4],[15,[0,13]]],[1,1]]')

      # after split
      expect(c.reduce).to be_truthy
      expect(c.to_s).to eq('[[[[0,7],4],[[7,8],[0,13]]],[1,1]]')

      # after split
      expect(c.reduce).to be_truthy
      expect(c.to_s).to eq('[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]')

      # after explode
      expect(c.reduce).to be_truthy
      expect(c.to_s).to eq('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]')

      expect(c.reduce).to be_falsey
      expect(c.to_s).to eq('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]')
    end
  end

  describe '+' do
    it '[[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]' do
      a = described_class.build_tree([[[[4, 3], 4], 4], [7, [[8, 4], 9]]])
      b = described_class.build_tree([1, 1])
      expect((a + b).to_s).to eq('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]')
    end
  end

  describe 'magnitude' do
    it '[9,1]' do
      expect(described_class.magnitude(described_class.build_tree([9, 1]))).to eq(29)
    end

    it '[1,9]' do
      expect(described_class.magnitude(described_class.build_tree([1, 9]))).to eq(21)
    end

    it '[[9,1],[1,9]]' do
      expect(described_class.magnitude(described_class.build_tree([[9, 1], [1, 9]]))).to eq(129)
    end

    it '[[1,2],[[3,4],5]]' do
      expect(described_class.magnitude(described_class.build_tree([[1, 2], [[3, 4], 5]]))).to eq(143)
    end

    it '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]' do
      expect(described_class.magnitude(described_class.build_tree([[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]))).to eq(1384)
    end

    it '[[[[1,1],[2,2]],[3,3]],[4,4]]' do
      expect(described_class.magnitude(described_class.build_tree([[[[1, 1], [2, 2]], [3, 3]], [4, 4]]))).to eq(445)
    end

    it '[[[[3,0],[5,3]],[4,4]],[5,5]]' do
      expect(described_class.magnitude(described_class.build_tree([[[[3, 0], [5, 3]], [4, 4]], [5, 5]]))).to eq(791)
    end

    it '[[[[5,0],[7,4]],[5,5]],[6,6]]' do
      expect(described_class.magnitude(described_class.build_tree([[[[5, 0], [7, 4]], [5, 5]], [6, 6]]))).to eq(1137)
    end

    it '[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]' do
      expect(described_class.magnitude(described_class.build_tree([[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]))).to eq(3488)
    end
  end

  describe 'part_1' do
    it '[[[[1,1],[2,2]],[3,3]],[4,4]]' do
      ans = [[1, 1], [2, 2], [3, 3], [4, 4]].map { |n| described_class.build_tree(n) }.reduce(:+)
      expect(ans.to_s).to eq('[[[[1,1],[2,2]],[3,3]],[4,4]]')
    end

    it '[[[[3,0],[5,3]],[4,4]],[5,5]]' do
      ans = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]].map { |n| described_class.build_tree(n) }.reduce(:+)
      expect(ans.to_s).to eq('[[[[3,0],[5,3]],[4,4]],[5,5]]')
    end

    context 'a slightly larger example' do
      it '[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]] + [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]' do
        ans = [
          [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
          [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]')
      end

      it '[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]] + [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]' do
        ans = [
          [[[[4, 0], [5, 4]], [[7, 7], [6, 0]]], [[8, [7, 7]], [[7, 9], [5, 0]]]],
          [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]')
      end

      it '[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]] + [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]' do
        ans = [
          [[[[6, 7], [6, 7]], [[7, 7], [0, 7]]], [[[8, 7], [7, 7]], [[8, 8], [8, 0]]]],
          [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]')
      end

      it '[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]] + [7,[5,[[3,8],[1,4]]]]' do
        ans = [
          [[[[7, 0], [7, 7]], [[7, 7], [7, 8]]], [[[7, 7], [8, 8]], [[7, 7], [8, 7]]]],
          [7, [5, [[3, 8], [1, 4]]]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]')
      end

      it '[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]] + [[2,[2,2]],[8,[8,1]]]' do
        ans = [
          [[[[7, 7], [7, 8]], [[9, 5], [8, 7]]], [[[6, 8], [0, 8]], [[9, 9], [9, 0]]]],
          [[2, [2, 2]], [8, [8, 1]]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]')
      end

      it '[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]] + [2,9]' do
        ans = [
          [[[[6, 6], [6, 6]], [[6, 0], [6, 7]]], [[[7, 7], [8, 9]], [8, [8, 1]]]],
          [2, 9]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]')
      end

      it '[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]] + [1,[[[9,3],9],[[9,0],[0,7]]]]' do
        ans = [
          [[[[6, 6], [7, 7]], [[0, 7], [7, 7]]], [[[5, 5], [5, 6]], 9]],
          [1, [[[9, 3], 9], [[9, 0], [0, 7]]]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]')
      end

      it '[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]] + [[[5,[7,4]],7],1]' do
        ans = [
          [[[[7, 8], [6, 7]], [[6, 8], [0, 8]]], [[[7, 7], [5, 0]], [[5, 5], [5, 6]]]],
          [[[5, [7, 4]], 7], 1]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]')
      end

      it '[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]] + [[[[4,2],2],6],[8,7]]' do
        ans = [
          [[[[7, 7], [7, 7]], [[8, 7], [8, 7]]], [[[7, 0], [7, 7]], 9]],
          [[[[4, 2], 2], 6], [8, 7]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]')
      end
    end

    context 'homework assignment' do
      it 'works' do
        ans = [
          [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
          [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
          [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
          [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
          [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
          [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
          [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
          [[9, 3], [[9, 9], [6, [4, 9]]]],
          [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
          [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]]
        ].map { |n| described_class.build_tree(n) }.reduce(:+)

        expect(ans.to_s).to eq('[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]')
        expect(described_class.magnitude(ans)).to eq(4140)
      end
    end

    context 'input' do
      it 'works' do
        expect(described_class.part_1.to_s).to eq('[[[[7,7],[7,0]],[[7,7],[7,7]]],[[[7,7],[7,7]],[6,7]]]')
      end
    end
  end

  describe 'part_2' do
    it 'works' do
      list = [
        [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
        [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
        [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
        [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
        [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
        [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
        [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
        [[9, 3], [[9, 9], [6, [4, 9]]]],
        [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
        [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]]
      ].map { |array| described_class.build_tree(array) }

      max_magnitude = 0
      (0...list.length).each do |i|
        (0...list.length).each do |j|
          next if i == j

          mag = described_class.magnitude(list[i] + list[j])
          max_magnitude = [max_magnitude, mag].max
        end
      end

      expect(max_magnitude).to eq(3993)
    end

    context 'input' do
      it 'works' do
        expect(described_class.part_2).to eq(4555)
      end
    end
  end
end
