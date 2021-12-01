input = File.read("input").split("\n").map(&:to_i)
puts "Input size #{input.size}"

num_increases = 0
input.drop(1).each_with_index do |measurement, idx|
  num_increases += 1 if measurement > input[idx]
end
puts "Answer #{num_increases}"
