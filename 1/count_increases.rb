input = File.read("input").split("\n").map(&:to_i)
puts "Input size #{input.size}"

puts "2 measurements"
num_increases = 0
input.each_cons(2) do |measurements|
  num_increases += 1 if measurements[0] < measurements[1]
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
