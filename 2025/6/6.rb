lines = File.read("input.txt").lines.map(&:chomp)
max_length = lines.map(&:length).max

transposed = lines.map { |line| line.ljust(max_length).chars }.transpose

split_cols = []
transposed.each_with_index do |t_line, i|
  split_cols << i if t_line.all? { _1 == " " }
end

problem_cols = []
cut_from = 0

while split_cols.size > 0
  cut_to = split_cols.shift
  problem_cols << transposed[cut_from..cut_to-1]
  cut_from = cut_to+1
end
problem_cols << transposed[cut_from..-1]

problems = problem_cols.map(&:transpose)

def solve(problem_lines)
  nums = problem_lines[..-2].map(&:to_i)
  op = problem_lines[-1][0]

  nums.reduce(op.to_sym)
end

# part 1
puts problems.map { solve(_1.map(&:join)) }.sum


# part 2
def solve_p2(problem_cols)
  nums = problem_cols.map { _1[..-1].to_i }
  op = problem_cols[0][-1]

  nums.reduce(op.to_sym)
end

puts problem_cols.map { solve_p2(_1.map(&:join)) }.sum
