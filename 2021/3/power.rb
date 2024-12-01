# frozen_string_literal: true

input = File.read('input').split("\n").map { _1.chars }

bit_freqs = input.transpose.each_with_object([]) do |col, bit_freqs_at_pos|
  ones = col.count { _1 == '1' }
  zeros = col.count { _1 == '0' }
  bit_freqs_at_pos << { 1 => ones, 0 => zeros }
end

gamma_rate = bit_freqs.map { _1[1] > _1[0] ? '1' : '0' }.join.to_i(2)
epsilon_rate = bit_freqs.map { _1[1] < _1[0] ? '1' : '0' }.join.to_i(2)

puts "Answer: #{gamma_rate * epsilon_rate}"
