# frozen_string_literal: true

input = File.read("input").split(',').map(&:to_i) # 500 items
days = 256

# input = [3, 4, 3, 1, 2]
# days = 18

# idx = days until copy
fish_counters = (0..8).map do |idx| 
  input.count { _1 == idx }
end
puts "Initial #{fish_counters}"

def advance(counts)
  new_gen_size = counts.shift
  counts[6] += new_gen_size
  counts[8] = new_gen_size
end

(1..days).each do |n|
  puts "Day #{n}, counts: #{fish_counters}"
  advance(fish_counters)
end
puts "Answer: #{fish_counters.sum}"