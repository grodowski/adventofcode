# frozen_string_literal: true

require 'benchmark'

LLElement = Struct.new(:next_el, :value) do
  def self.from_s(str)
    root = LLElement.new(nil, str[0].to_sym)
    tail = root
    str[1..-1].each do |char|
      tail.insert_after(char)
      tail = tail.next_el
    end
    root
  end

  def insert_after(new_value)
    self.next_el = LLElement.new(next_el, new_value.to_sym)
  end

  alias :to_sym :value

  def size
    collect.size
  end

  def inspect
    "<Node:#{object_id} #{self.value}>"
  end

  def collect
    str = ""
    head = self
    while head = head.next_el
      str += head.value
    end
    str
  end
end

def insert(polymer, rules)
  head = polymer
  while pair = head.next_el
    head.insert_after(rules[head.to_sym][pair.to_sym])
    head = pair
  end
  polymer
end

input = File.read('input_small').lines.map(&:chomp)
polymer = LLElement.from_s(input[0].chars)
rules = input[2..-1].each_with_object({}) do |line, instructions_hash|
  pair, addition = line.split(" -> ")
  instructions_hash[pair[0].to_sym] ||= {}
  instructions_hash[pair[0].to_sym][pair[1].to_sym] = addition.to_sym
end

40.times do |n|
  bm = Benchmark.measure { insert(polymer, rules) }
  puts "After #{n}: #{bm.real} mem: #{`ps -o rss #{Process.pid}`.lines.last.to_i / 1024} Mb"
end

counts = polymer.collect.chars.group_by { _1 }.transform_values(&:size)
most_common = counts.values.max
least_common = counts.values.min
puts "Answer: #{most_common - least_common}"
