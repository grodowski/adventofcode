# frozen_string_literal: true

class Octopus
  attr_reader :x, :y, :energy, :flashed, :counter

  def initialize(x, y, energy, grid)
    @x = x
    @y = y
    @energy = energy
    @grid = grid
    @counter = 0
    @flashed = false
  end

  # if energy = 9, increase each energy level by 1
  # if flashes, increase neighbouring levels by 
  # energy set back to 0
  # each can flash only once per step
  def step
    @energy += 1
  end

  def flash
    return if @flashed

    if @energy > 9
      @flashed = true
      @counter += 1
      @grid.flashed(self)
    end
  end

  def on_flash(x, y)
    return if @flashed

    if (@x - x).abs <= 1 && (@y - y).abs <= 1
      step
      flash
    end
  end

  def reset
    @energy = 0 if @flashed
    @flashed = false
  end
end

class Grid
  def initialize(grid_rows_raw)
    @grid_rows = grid_rows_raw.map.with_index do |row, y|
      row.map.with_index { |energy, x| Octopus.new(x, y, energy, self) }
    end
    @octopuses = @grid_rows.flatten
  end

  def step
    @octopuses.each(&:step)
    @octopuses.each(&:flash)
    all_flashed = @octopuses.all?(&:flashed)
    @octopuses.each(&:reset)

    all_flashed
  end

  def flashed(octopus)
    @octopuses.each { _1.on_flash(octopus.x, octopus.y) }
  end

  def counter
    @octopuses.sum(&:counter)
  end

  def to_s
    @grid_rows.map { _1.map { |octopus| octopus.energy }.join }.join("\n")
  end

  def pretty_print
    escape = ("\033[A" * (@grid_rows.size)) + "\r"
    # escape = "\n"
    "Answer: #{counter}\n" + to_s + escape
  end
end

steps = 1000
grid = Grid.new(File.read('input').lines.map { |line| line.chomp.chars.map(&:to_i) })

print grid.pretty_print
sleep 1

first_all_flashed_n = nil
steps.times do |n|
  if all_flashed = grid.step
    first_all_flashed_n = n + 1 if first_all_flashed_n.nil?
  end
  print grid.pretty_print
end

puts "Answer 1: #{grid.counter}"
puts "Answer 2: #{first_all_flashed_n}"
