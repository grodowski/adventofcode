# rubocop:disable all
# Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?

Priorities = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze

Rucksack = Struct.new(:left, :right) do
  def score
    to_points = left & right

    to_points.sum { priority(_1) }
  end

  def elems
    left + right
  end

  def priority(char)
    Priorities.index(char) + 1
  end
end

rucksacks = File.readlines("input").map do |items|
  left, right = items.chars.each_slice(items.size / 2).to_a
  Rucksack.new(left, right)
end

puts rucksacks.sum(&:score)

# P2 - find common elements in group of 3, then sum all the common elements
total = rucksacks.each_slice(3).sum do |group|
  common = group[0].elems & group[1].elems & group[2].elems

  Priorities.index(common[0]) + 1
end
puts total
