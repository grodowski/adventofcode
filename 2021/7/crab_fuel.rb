# frozen_string_literal: true

# positions = [16,1,2,0,4,2,7,1,2,14]
positions = File.read('input').split(',').map(&:to_i)

def cost_fn(crab_positions, target_idx)
  # sum arithmetic series
  crab_positions.sum do |pos|
    # part 1 is just const cost of 1: (pos - target_idx).abs
    n = (pos - target_idx).abs
    (1 + n) * n / 2
  end
end

min = Float::INFINITY
minpos = nil
(0..positions.max).each do |pos|
  cost = cost_fn(positions, pos)
  if cost < min
    min = cost
    minpos = pos
  end
end

puts "Answer: #{min} at pos #{minpos}"
