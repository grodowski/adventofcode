require 'matrix'

class Vector
  attr_accessor :cluster_id
end

vectors = File.readlines("input.txt", chomp: true).map do |line|
  Vector[*line.split(',').map(&:to_i)]
end

def calc_distances(vectors)
  vectors.combination(2).map do |(v1, v2)|
    dist = (v1 - v2).norm
    [dist, [v1, v2]]
  end.sort_by { _1[0] }
end

vec_dist = calc_distances(vectors)
cluster_id_seq = 0
target_pairs = 1000

vec_dist.first(target_pairs).each_with_index do |(dist, (x, y)), i|
  if x.cluster_id && y.cluster_id && x.cluster_id == y.cluster_id
    next
  end

  if x.cluster_id && y.cluster_id
    old_cluster = y.cluster_id
    new_cluster = x.cluster_id
    vectors.each do |v|
      v.cluster_id = new_cluster if v.cluster_id == old_cluster
    end
  else
    cluster_id = x.cluster_id || y.cluster_id || (cluster_id_seq += 1)
    x.cluster_id = cluster_id
    y.cluster_id = cluster_id
  end

  if (i + 1) % 100 == 0 || i < 20
    current_groups = vectors.group_by(&:cluster_id).reject { |k, v| k.nil? }
    sizes = current_groups.values.map(&:size).sort.reverse
  end
end
groups = vectors.group_by(&:cluster_id)

unconnected_count = groups[nil]&.size || 0
connected_groups = groups.reject { |k, v| k.nil? }.values

all_circuit_sizes = connected_groups.map(&:size) + [1] * unconnected_count

puts "Circuit sizes: #{all_circuit_sizes.sort.reverse}"
puts "Answer: #{all_circuit_sizes.sort.reverse.take(3).reduce(:*)}"

# part 2
vec_dist.each_with_index do |(dist, (x, y)), i|
  if x.cluster_id && y.cluster_id && x.cluster_id == y.cluster_id
    next
  end

  if x.cluster_id && y.cluster_id
    old_cluster = y.cluster_id
    new_cluster = x.cluster_id
    vectors.each do |v|
      v.cluster_id = new_cluster if v.cluster_id == old_cluster
    end
  else
    cluster_id = x.cluster_id || y.cluster_id || (cluster_id_seq += 1)
    x.cluster_id = cluster_id
    y.cluster_id = cluster_id
  end

  if (i + 1) % 100 == 0 || i < 20
    current_groups = vectors.group_by(&:cluster_id).reject { |k, v| k.nil? }
    sizes = current_groups.values.map(&:size).sort.reverse
  end

  if vectors.map(&:cluster_id).uniq.size == 1
    puts "Last junction: #{x}, #{y}. Answer: #{x[0] * y[0]}"
    break
  end
end
