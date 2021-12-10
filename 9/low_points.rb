require 'set'

rows = File.read('input').lines.map { _1.chars[0..-2].map(&:to_i) }

low_point_search = []
rows.each_with_index do |row, y|
  row.each_with_index do |col, x|
    is_low_point = [
      (y == 0 ? nil : true) && rows[y - 1] && rows[y - 1][x], # top
      row[x + 1], # right
      rows[y + 1] && rows[y + 1][x], # bottom
      row[x - 1], # left
    ].compact
    low_point_search << {x: x, y: y, value: col} if is_low_point.all? { _1 > col }
  end
end

puts "Answer 1: #{low_point_search.map { 1 + _1[:value] }.sum}"

# What do you get if you multiply together the sizes of the three largest basins?
def expand_basin(x, y, rows, map)
  return if rows[y].nil? || rows[y][x].nil? || rows[y][x] == 9 || map.include?([x, y])

  map.add([x, y])

  expand_basin(x, y - 1, rows, map) if y > 0
  expand_basin(x, y + 1, rows, map)
  expand_basin(x - 1, y, rows, map) if x > 0
  expand_basin(x + 1, y, rows, map)

  map
end

basins = []
low_point_search.each do |x:, y:, value:|
  basins << expand_basin(x, y, rows, Set.new)
end
puts "Answer 2: #{basins.sort_by { _1.size }.last(3).reduce(1) { |memo, b| memo * b.size }}"


