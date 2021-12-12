# frozen_string_literal: true

class Octopus
  attr_reader :x, :y, :counter

  def initialize(x, y, energy, grid)
    @x = x
    @y = y
    @energy = energy
    @grid = grid
    @counter = 0
  end

  # if energy = 9, increase each energy level by 1
  # if flashes, increase neighbouring levels by 
  # energy set back to 0
  # each can flash only once per step
  def step
    @flashed = false
    puts "#{self.object_id}: #{@energy}"
    @energy += 1
    if @energy > 9
      @flashed = true
      @counter += 1
      @grid.flashed(self)
      @energy = 0
    end
  end

  def on_flash(x, y)
    return if @flashed
    step if (@x - x).abs <= 1 && (@y - y).abs <= 1
  end
end

class Grid
  @flashes = 0
  def initialize(grid_rows_raw)
    @grid_rows = grid_rows_raw.map.with_index do |row, y|
      row.map.with_index { |energy, x| Octopus.new(x, y, energy, self) }
    end
  end

  def step
    # require 'pry'; binding.pry
    @grid_rows.flatten.each(&:step)
  end

  def flashed(octopus)
    @grid_rows.flatten.each { _1.on_flash(octopus.x, octopus.y) }
  end

  def counter
    @grid_rows.flatten.sum(&:counter)
  end
end

steps = 100
grid = Grid.new(File.read('input').lines.map { |line| line.chomp.chars.map(&:to_i) })
steps.times do |n|
  grid.step
  
end
puts "Answer: #{grid.counter}"
