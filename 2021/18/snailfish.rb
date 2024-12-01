# frozen_string_literal: true

class SnailPair
  attr_reader :left, :right
  def initialize(tup)
    left, right = tup
    @left = left.is_a?(Array) ? SnailPair.new(left) : left
    @right = right.is_a?(Array) ? SnailPair.new(right) : right
  end

  # If any pair is nested inside four pairs, the leftmost such pair explodes.
  # If any regular number is 10 or greater, the leftmost such regular number splits.
  # Once no action in the above list applies, the snailfish number is reduced.
  def reduce
    traverse_and_explode
    self
  end

  def +(other)
    SnailPair.new([self, other]).reduce
  end

  def zero(target)
    @left = 0 if target == left
    @right = 0 if target == right
  end

  def inspect
    l_to_s = left.is_a?(SnailPair) ? left.inspect : left
    r_to_s = right.is_a?(SnailPair) ? right.inspect : right
    "[#{l_to_s}, #{r_to_s}]"
  end
  alias to_s inspect

  def traverse_and_explode(visited_stack = [])
    if visited_stack.size == 4
      puts "to explode #{self}"
      parent = visited_stack.pop
      puts "parent #{parent}"
      parent.zero(self)

      return true # wtf how to make this exit earlier........
    end

    visited_stack.push(self)
    each_child do |lr|
      exploded = lr.traverse_and_explode(visited_stack)
      break if exploded
    end
  end

  def each_child
    yield left if left.is_a?(SnailPair)
    yield right if right.is_a?(SnailPair)
  end

  # def split_numeric(number)
  #   return number if number < 10

  #   SnailPair.new((number / 2).floor, (number / 2).ceil)
  # end
end

total = nil
File.read("input_small").lines do |line|
  raw = (eval line)
  unless total
    total = SnailPair.new(raw)
  else
    total = total + SnailPair.new(raw)
  end
end
pp total
