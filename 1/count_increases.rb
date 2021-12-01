input = File.read("input").split("\n").map(&:to_i)
puts "Input size #{input.size}"

num_increases = 0
input.drop(1).each_with_index do |measurement, idx|
  num_increases += 1 if measurement > input[idx]
end
puts "Answer 1 #{num_increases}"

puts "Sliding window of 3 measurements"
num_increases = 0
prev_sum = nil
input.each_cons(3) do |measurements|
  new_sum = measurements.sum
  num_increases += 1 if prev_sum && new_sum > prev_sum
  prev_sum = new_sum
end
puts "Answer 2 #{num_increases}"
