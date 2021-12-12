# frozen_string_literal: true
require 'set'

class Node
  attr_reader :name, :to

  def initialize(name)
    @name = name
    @to = Set.new
  end

  def start?
    name == 'start'
  end

  def end?
    name == 'end'
  end

  def small?
    name == name.downcase
  end

  def each_conn(&block)
    @to.each(&block)
  end

  def to_s
    name
  end
  alias :inspect :to_s
end

class CaveMap
  def initialize
    @nodes = []
  end

  def parse_and_add(line_str)
    start_s, end_s = line_str.split('-')
    add(start_s, end_s)
  end

  def add(start_s, end_s)
    start_n = locate_or_create(start_s)
    end_n = locate_or_create(end_s)
    start_n.to.add(end_n)
    end_n.to.add(start_n)
  end

  def generate_paths
    visited = Hash.new { 0 }
    start = locate_or_create('start')

    paths = []
    traverse_until_end(visited, [start], paths)

    paths
  end

  def traverse_until_end(visited, path, paths)
    visited[path.last] += 1

    path.last.each_conn do |child|
      # require 'pry'; binding.pry
      if child.end?
        # stop traversing this path at end? == true
        visited[child] += 1
        path << child
        paths << path
      elsif child.start?
        # not interesting, do not go there
      elsif child.small?
        no_small_visited_twice_yet = visited.select { |k, _v| k.small? }.all? { |_k, v| v <= 1 }
        if visited[child] < 1 || no_small_visited_twice_yet
          traverse_until_end(visited.dup, path.dup + [child], paths)
        end
      else
        # go depth first
        traverse_until_end(visited.dup, path.dup + [child], paths)
      end
    end
  end

  private

  def locate_or_create(name)
    @nodes.find { _1.name == name } || Node.new(name).tap { @nodes << _1 }
  end
end

# How many disinct paths are there that visit small caves at most once?
map = CaveMap.new
File.read("input").lines.map(&:chomp).each { |conn| map.parse_and_add(conn) }
paths = map.generate_paths
pp paths
pp "Answer: #{paths.size}"
