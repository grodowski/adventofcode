lines = File.read("input.txt").lines
i = lines.index("\n")

fresh_ranges = lines[...i].map do |line|
  start_val, end_val = line.strip.split('-').map(&:to_i)
  (start_val..end_val)
end

ids = lines[(i + 1)..].map { |line| line.strip.to_i }

valid_count = ids.count do |id|
  fresh_ranges.any? { |range| range.cover?(id) }
end

puts "Part 1: #{valid_count}"

def merge_ranges(ranges)
  sorted = ranges.sort_by(&:begin)
  merged = []
  
  current = sorted.first
  
  sorted[1..].each do |range|
    if range.begin <= current.end + 1
      current = (current.begin..[current.end, range.end].max)
    else
      merged << current
      current = range
    end
  end
  
  merged << current
  merged
end

merged_ranges = merge_ranges(fresh_ranges)
total_fresh = merged_ranges.sum { |range| range.size }

puts "Part 2: #{total_fresh}"
