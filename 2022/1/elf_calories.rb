# rubocop:disable all
# Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?

input = File.readlines("input")

elf_calories = input.chunk { _1.strip == "" }.map do |separator, elf_calories|
  next if separator

  elf_calories.map(&:to_i)
end.compact

total_elf_calories = elf_calories.map(&:sum)

puts total_elf_calories.index(total_elf_calories.sort.reverse.first)
puts total_elf_calories.sort.reverse[0..2].sum
