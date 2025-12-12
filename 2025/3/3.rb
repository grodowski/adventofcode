# part 1
def max_two_digits_sorted(digits)
  max_first_val = digits[..-2].max
  remaining = digits[(digits.index(max_first_val) + 1)..]
  max_first_val * 10 + remaining.max
end

# part 2
def max_n_digits_sorted(digits, n)
  return "" if n == 0
  max_first_val = digits[..-n].max

  remaining = digits[(digits.index(max_first_val) + 1)..]
  max_first_val.to_s + max_n_digits_sorted(remaining, n - 1)
end


banks = File.read("input.txt").lines.map do |line|
  puts line
  digits = line.strip.chomp.chars.map(&:to_i)
  # max_two_digits_sorted(digits)
  max_n_digits_sorted(digits, 12).to_i
end
puts banks.sum
