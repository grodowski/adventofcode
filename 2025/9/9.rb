#!/usr/bin/env ruby
require 'set'

def parse_input(filename)
  File.readlines(filename).map do |line|
    next if line.strip.empty?
    x, y = line.strip.split(',').map(&:to_i)
    [x, y]
  end.compact
end

def part1(red_tiles)
  max_area = 0
  red_tiles.each_with_index do |tile1, i|
    red_tiles[i+1..-1].each do |tile2|
      x1, y1 = tile1
      x2, y2 = tile2
      area = ((x2 - x1).abs + 1) * ((y2 - y1).abs + 1)
      max_area = [max_area, area].max
    end
  end
  max_area
end

def part2(red_tiles)
  # Build boundary and extract edges
  boundary = Set.new
  edges = []

  red_tiles.each_with_index do |tile1, i|
    tile2 = red_tiles[(i + 1) % red_tiles.size]
    x1, y1 = tile1
    x2, y2 = tile2
    edges << [tile1, tile2]

    if x1 == x2
      [y1, y2].min.upto([y1, y2].max) { |y| boundary.add([x1, y]) }
    else
      [x1, x2].min.upto([x1, x2].max) { |x| boundary.add([x, y1]) }
    end
  end

  puts "Boundary: #{boundary.size} points, Edges: #{edges.size}"

  # Standard point-in-polygon ray casting
  def point_inside?(px, py, polygon)
    inside = false
    j = polygon.size - 1

    polygon.size.times do |i|
      xi, yi = polygon[i]
      xj, yj = polygon[j]

      if ((yi > py) != (yj > py)) && (px < (xj - xi) * (py - yi) / (yj - yi).to_f + xi)
        inside = !inside
      end
      j = i
    end
    inside
  end

  # Check if point is valid (on boundary or inside)
  def point_valid?(x, y, boundary, polygon)
    boundary.include?([x, y]) || point_inside?(x, y, polygon)
  end

  # Fast rectangle validation using edge crossing check
  def rect_valid?(x1, y1, x2, y2, boundary, polygon, edges)
    min_x, max_x = [x1, x2].minmax
    min_y, max_y = [y1, y2].minmax

    # Check all four corners
    [[min_x, min_y], [min_x, max_y], [max_x, min_y], [max_x, max_y]].each do |x, y|
      return false unless point_valid?(x, y, boundary, polygon)
    end

    # Check if any polygon edge crosses through rectangle interior
    edges.each do |(ex1, ey1), (ex2, ey2)|
      if ex1 == ex2  # Vertical edge
        # Check if this vertical edge crosses horizontally through rectangle
        if ex1 > min_x && ex1 < max_x
          edge_y_min, edge_y_max = [ey1, ey2].minmax
          # Does edge overlap with rectangle's y-range?
          if edge_y_min < max_y && edge_y_max > min_y
            return false
          end
        end
      else  # Horizontal edge
        # Check if this horizontal edge crosses vertically through rectangle
        if ey1 > min_y && ey1 < max_y
          edge_x_min, edge_x_max = [ex1, ex2].minmax
          # Does edge overlap with rectangle's x-range?
          if edge_x_min < max_x && edge_x_max > min_x
            return false
          end
        end
      end
    end

    true
  end

  max_area = 0
  best_rect = nil

  red_tiles.each_with_index do |tile1, i|
    puts "Progress: #{i}/#{red_tiles.size}, max: #{max_area}" if i % 50 == 0

    red_tiles[i+1..-1].each do |tile2|
      x1, y1 = tile1
      x2, y2 = tile2

      if rect_valid?(x1, y1, x2, y2, boundary, red_tiles, edges)
        area = ((x2 - x1).abs + 1) * ((y2 - y1).abs + 1)
        if area > max_area
          max_area = area
          best_rect = [x1, y1, x2, y2]
        end
      end
    end
  end

  puts "Best: #{best_rect.inspect}"
  max_area
end

red_tiles = parse_input('input.txt')
puts "Loaded #{red_tiles.size} red tiles\n\n"

puts "=== Part 1 ==="
puts part1(red_tiles)
puts

puts "=== Part 2 ==="
puts part2(red_tiles)
