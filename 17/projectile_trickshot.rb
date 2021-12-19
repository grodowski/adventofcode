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

# maximize y, such that it reaches target area

v_x = rand(120)
v_y = rand(120)

best = [v_x, v_y, 0, nil]
iter = 0
# maximisation loop
loop do
  iter += 1
  prev_best = best

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

  closest_hit = path.find { |p| p.in_target?(x, y) } || path.last
  if closest_hit.in_target?(x, y)
    # there still might be a more *stylish* solution -> try increasng y
    max_y = path.max(&:y).y
    best = [v_x, v_y, max_y, path] unless best[2] > max_y
    v_y += 1
  elsif projectile.x > x.end
    v_x -= 1
  elsif projectile.x < x.begin
    # didn't reach target x
    v_x += 1
  end

  break if prev_best == best && iter > 10_000
end

pp "Answer 1: #{best}"
