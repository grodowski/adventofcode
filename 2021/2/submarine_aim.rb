# frozen_string_literal: true

Inst = Struct.new(:direction, :distance) do
  def self.from_line(line)
    dir, dist = *line.split(' ')
    new(dir, dist.to_i)
  end
end

Pos = Struct.new(:x, :y, :aim) do
  def move(instr)
    case instr.direction
    when 'forward'
      self.class.new(x + instr.distance, y + aim * instr.distance, aim)
    when 'up'
      self.class.new(x, y, aim - instr.distance)
    when 'down'
      self.class.new(x, y, aim + instr.distance)
    end
  end
end

instructions = File.read('input').split("\n").map { Inst.from_line(_1) }
position = Pos.new(0, 0, 0)
instructions.each do |instr|
  position = position.move(instr)
end
puts "Answer: #{position.x * position.y}"
