# rubocop:disable all
# In how many assignment pairs does one range fully contain the other?

cover = proc { |s1, e1, s2, e2| (s1..e1).cover?(s2..e2) || (s2..e2).cover?(s1..e1) }
overlap = proc do |s1, e1, s2, e2|
  s1 <= s2 ? e1 >= s2 : e2 >= s1
end

total_overlapping = File.readlines("input").inject(0) do |sum, line|
  s1, e1, s2, e2 = line.strip.scan(/(\d+)-(\d+)/).flatten.map(&:to_i)
  cover.(s1, e1, s2, e2) ? sum + 1 : sum
end
puts total_overlapping


total_any_overlap = File.readlines("input").inject(0) do |sum, line|
  s1, e1, s2, e2 = line.strip.scan(/(\d+)-(\d+)/).flatten.map(&:to_i)
  overlap.(s1, e1, s2, e2) ? sum + 1 : sum
end
puts total_any_overlap
