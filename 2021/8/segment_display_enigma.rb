# frozen_string_literal: true
#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

# inputs = [
#   [[
#     "acdeg",
#     "abcdfg",
#     "acdefg",
#     "cdefg",
#     "abcdefg",
#     "bcdefg",
#     "acg",
#     "acef",
#     "abdeg",
#     "ac"
#   ],
#   ["acg", "bcdefg", "acg", "acef"]]
# ].map { |(inp, out)| [inp.map(&:chars), out.map(&:chars)] }
inputs = File.read('input').lines.map do |line|
  line.split(' | ').map { |in_out| in_out.split(' ').map { _1.chars.sort } }
end

# find 1, 4, 7 and 8 in the outputs
answer = inputs.sum { |_in, out| out.count { [2, 3, 4, 7].include?(_1.length) } }
puts "Answer 1: #{answer}"

num_to_code = {}
results = []
inputs.each do |input, output|
  # figure out mapping between segments and numbers
  num_to_code = {}
  input.map do |code|
    case code.length
    when 2
      num_to_code[1] = code
    when 4
      num_to_code[4] = code
    when 3
      num_to_code[7] = code
    when 7
      num_to_code[8] = code
    end
  end
  input.delete(num_to_code[1])
  input.delete(num_to_code[4])
  input.delete(num_to_code[7])
  input.delete(num_to_code[8])

  # guess remaining numbers 0, 2, 3, 5, 6, 9
  num_to_code[3] = input.select { _1.length == 5 && (num_to_code[7] - _1).empty? }.first
  input.delete(num_to_code[3])

  num_to_code[9] = input.select { _1.length == 6 && (_1 - num_to_code[4]).size == 2 }.first
  input.delete(num_to_code[9])

  num_to_code[0] = input.select { _1.size == 6 && (num_to_code[7] - _1).empty? }.first
  input.delete(num_to_code[0])

  num_to_code[6] = input.select { _1.length == 6 && (num_to_code[8] - _1).size == 1 }.first
  input.delete(num_to_code[6])

  num_to_code[2] = input.select { (num_to_code[6] - _1).size == 2 }.first
  input.delete(num_to_code[2])

  num_to_code[5] = input.last

  results << output.map { |code| num_to_code.invert[code].to_s }.join.to_i
end
puts "Answer 2: #{results.sum}"
