# frozen_string_literal: true

input = File.read('input').split("\n").map { _1.chars }
# input = File.read('input_small').split("\n").map { _1.chars }

def bit_freqs(input)
  input = input.transpose
  input.each_with_object([]) do |col, bit_freqs_at_pos|
    ones = col.count { _1 == '1' }
    zeros = col.count { _1 == '0' }
    bit_freqs_at_pos << { 1 => ones, 0 => zeros }
  end
end

# filter input column by column until one val is left
# mode (:most, :least)
def search_recursive(input, column = 0, mode = :most)
  puts "Col #{column}, input size #{input.size}"
  return input if input.size == 1

  bit_freqs_at_col = bit_freqs(input)[column]
  bit_to_keep = case mode
                when :most
                  if bit_freqs_at_col[1] == bit_freqs_at_col[0]
                    1
                  else
                    bit_freqs_at_col.invert.max.last
                  end
                when :least
                  if bit_freqs_at_col[1] == bit_freqs_at_col[0]
                    0
                  else
                    bit_freqs_at_col.invert.min.last
                  end
                end
  puts "bit_to_keep #{bit_to_keep}"
  input = input.keep_if { |row| row[column] == bit_to_keep.to_s }

  search_recursive(input, column + 1, mode)
end

puts 'oxygen, most common bit stays'
oxygen_rating = search_recursive(input.dup, 0, :most).join.to_i(2)

puts 'co2, least common bit stays'
# least common value stays
co2_scrubber_rating = search_recursive(input.dup, 0, :least).join.to_i(2)

puts "Answer: #{oxygen_rating * co2_scrubber_rating}"
