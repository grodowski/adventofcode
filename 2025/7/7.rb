State = Struct.new(:beams, :count) do
  def split(splits)
    updated_beams = beams.dup
    split_points = (splits & beams)
    split_points.map do |split_idx|
      updated_beams.delete(split_idx)
      updated_beams.add(split_idx - 1)
      updated_beams.add(split_idx + 1)
    end

    if split_points.any?
      line = "." * 142
      beams.each do |idx|
        line[idx] = "|"
      end
      split_points.each do |idx|
        line[idx] = "^"
        line[idx - 1] = "|" if idx > 0
        line[idx + 1] = "|" if idx < line.length - 1
      end
      puts line
    else
      line = "." * 142
      updated_beams.each do |idx|
        line[idx] = "|"
      end
      puts line
    end

    State.new(updated_beams, count + split_points.size)
  end
end

state = nil

# part 2 - track path counts per position instead of full histories
PathCounts = Struct.new(:counts) do
  def expand(old_beams, new_beams, splits)
    new_counts = Hash.new(0)

    old_beams.each do |old_pos|
      path_count = counts[old_pos]

      if splits.include?(old_pos)
        # This beam split - paths double
        new_counts[old_pos - 1] += path_count
        new_counts[old_pos + 1] += path_count
      elsif new_beams.include?(old_pos)
        # This beam continued straight
        new_counts[old_pos] += path_count
      end
    end

    PathCounts.new(new_counts)
  end

  def total
    counts.values.sum
  end
end

path_counts = nil

File.read("input.txt").lines.map do |line|
  if s_idx = line.index("S")
    state = State.new(Set.new([s_idx]), 0)
    path_counts = PathCounts.new({ s_idx => 1 })
    next
  end

  splits = Set.new
  line.chars.each_with_index do |c, i|
    splits.add(i) if c == "^"
  end

  old_beams = state.beams.dup
  state = state.split(splits)
  path_counts = path_counts.expand(old_beams, state.beams, splits)
end

puts state.count
puts "Total unique paths: #{path_counts.total}"
