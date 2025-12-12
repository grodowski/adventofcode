require 'matrix'

grid = []
File.read("input.txt").lines do |line|
  grid << line.chomp.strip.chars.map do
    _1 == '@' ? 1 : 0
  end
end

padded_grid = Array.new(grid.size + 2) { Array.new(grid[0].size + 2, 0) }
grid.each_with_index do |row, i|
  row.each_with_index do |val, j|
    padded_grid[i + 1][j + 1] = val
  end
end

matrix = Matrix[*padded_grid]
TRANSFORM_KERNEL = Matrix[
  [1, 1, 1],
  [1, 0, 1],
  [1, 1, 1]
].freeze

def transform_grid(matrix)
  (matrix.row_count - 2).times do |row|
    (matrix.column_count - 2).times do |col|
      submatrix = matrix.minor(row, 3, col, 3)
      product = submatrix.hadamard_product(TRANSFORM_KERNEL)
      filled_count = product.count { |v| v == 1 }

      yield row + 1, col + 1, filled_count < 4
    end
  end
end

def print_matrix(matrix, grid, title = "Matrix")
  puts "\n#{title}:"
  grid.size.times do |row|
    grid[0].size.times do |col|
      print matrix[row + 1, col + 1] == 1 ? '@' : '.'
    end
    puts
  end
end

def prune(matrix)
  copy = matrix.to_a.map(&:dup)
  moved_count = 0
  transform_grid(matrix) do |x, y, movable|
    next unless movable
    next if matrix[x, y] == 0

    copy[x][y] = 0
    moved_count += 1
  end
  [Matrix[*copy], moved_count]
end

total_sum = 0
transform_grid(matrix) do |_x, _y, movable|
  total_sum += 1 if movable
end
puts "Total sum: #{total_sum}"

MAXITER = 1000
i = 0
total_removed = 0
_matrix = nil

# print_matrix(matrix, grid, "Original matrix")

while i < MAXITER
  _matrix, moved_count = prune(matrix)

  print "\rEpoch #{i}: removed #{moved_count} cells (total: #{total_removed + moved_count})  "
  $stdout.flush

  total_removed += moved_count
  if moved_count > 0
    matrix = _matrix
    i += 1
  else
    break
  end
end

puts "Total moved: #{total_removed}"

print_matrix(matrix, grid, "Final matrix after #{i} iterations")
