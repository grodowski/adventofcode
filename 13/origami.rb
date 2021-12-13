# frozen_string_literal: true
input = File.read('input').lines

before_blank_separator = proc { _1 != "\n" }
dots = input.take_while(&before_blank_separator).map do |line|
  x, y = line.chomp.split(",").map(&:to_i)
  {x: x, y: y}
end

instructions = input.drop_while(&before_blank_separator)[1..-1].map do |line|
  axis, val = line.chomp.split("=")
  [axis[-1].to_sym, val.to_i]
end

def fold(origami, axis, value)
  to_fold = origami.select { |dot| dot[axis] > value }
  to_keep = origami.select { |dot| dot[axis] < value }
  folded = to_fold.map do |dot|
    a_prim = dot[axis] - 2 * (dot[axis] - value)
    dot[axis] = a_prim
    dot
  end
  (to_keep + folded).uniq
end

def draw(dots)
  max_x = dots.map { _1[:x] }.max
  max_y = dots.map { _1[:y] }.max
  canvas = Array.new(max_y + 1) { Array.new(max_x + 1, '.') }
  dots.each { |dot| canvas[dot[:y]][dot[:x]] = '#' }
  canvas.map { |row| row.join("") }.join("\n")
end

puts draw(dots)
fold_1 = fold(dots, instructions.first[0], instructions.first[1])
puts "\n#{draw(fold_1)}\n\n"
puts "Answer 1: #{fold_1.size}"

fold_2 = dots
instructions.each do |inst|
  fold_2 = fold(fold_2, inst[0], inst[1])
end
puts draw(fold_2)
# 🤯 Answer 2: 🤯
# #..#..##..#....####.###...##..####.#..#
# #..#.#..#.#.......#.#..#.#..#....#.#..#
# #..#.#....#......#..#..#.#..#...#..#..#
# #..#.#....#.....#...###..####..#...#..#
# #..#.#..#.#....#....#.#..#..#.#....#..#
# .##...##..####.####.#..#.#..#.####..##.
