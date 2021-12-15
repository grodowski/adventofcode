# frozen_string_literal: true
input = File.read('input').lines.map(&:chomp)

rules_and_counts = input[2..-1].each_with_object({}) do |line, h|
  pair, addition = line.split(" -> ")
  h[[pair[0].to_sym, pair[1].to_sym]] = {
    res: addition.to_sym,
    next_gen_size: 0,
    current_gen_size: 0
  }
end

# init with input
totals = rules_and_counts.keys.flatten.uniq.map { [_1, 0] }.to_h
input_polymer = input[0].chars.map(&:to_sym)
input_polymer.each do |char|
  totals[char] += 1
end
input_polymer.each_cons(2) do |pair|
  rules_and_counts[pair][:next_gen_size] += 1
end

def advance(current_gen, idx, totals)
  new_gen = current_gen.map do |k, v|
    [k, v.dup]
  end.to_h

  current_gen.each do |pair, result|
    addition = result[:res]
    count = result[:next_gen_size] - result[:current_gen_size]
    totals[addition] += count
    new_gen[[pair[0], addition]][:next_gen_size] += count
    new_gen[[addition, pair[1]]][:next_gen_size] += count
    new_gen[pair][:current_gen_size] = result[:next_gen_size]
    new_gen[pair][:idx] = idx
  end
  new_gen
end

new_gen = rules_and_counts
depth = 40
(1..depth).each { |n| new_gen = advance(new_gen, n, totals) }
puts "Answer: #{totals.values.max - totals.values.min}"
