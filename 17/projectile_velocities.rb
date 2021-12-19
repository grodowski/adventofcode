# frozen_string_literal: true

Projectile = Struct.new(:x, :y, :v_x, :v_y) do
  def step
    self.class.new(
      x + v_x,
      y + v_y,
      [v_x - 1, 0].max,
      v_y - 1
    )
  end

  def in_target?(target_x, target_y)
    target_x.include?(x) && target_y.include?(y)
  end
end

# x = 20..30
# y = -10..-5
# Target area for Answer 1
x = 150..171
y = -129..-70

search_space_x = 0..171
search_space_y = -129..129
starts = search_space_x.to_a.product(search_space_y.to_a)
in_target = 0
starts.each do |v_x, v_y|
  path = [Projectile.new(0, 0, v_x, v_y)]
  projectile = path.first
  # projectile generation loop
  loop do
    projectile = projectile.step
    path << projectile
    break if
      projectile.x > x.end ||
      (projectile.x < x.begin && projectile.v_x.zero?) ||
      (projectile.y < y.begin)
  end

  closest_hit = path.find { |p| p.in_target?(x, y) }
  in_target += 1 if closest_hit
end

puts "Answer 2: #{in_target}"
