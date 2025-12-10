IdRange = Struct.new(:range) do
  def sum_invalid
    # range.select { |id| id.to_s.match?(/^(.+)\1$/) }.sum # part 1
    range.select { |id| id.to_s.match?(/^(.+)\1+$/) }.sum # part 2
  end
end

id_ranges = File.read("input.txt").split(",").map do |range|
  val_start, val_end = range.split("-").map(&:to_i)
  IdRange.new((val_start..val_end))
end

total_invalid_sum = id_ranges.sum(&:sum_invalid)
puts total_invalid_sum
