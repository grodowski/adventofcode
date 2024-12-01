lines = File.open('input').readlines
lines = lines.map(&:chomp)
illegal_characters = []

class Bracket
  MAPPING = {
  '(' => ')',
  '{' => '}',
  '[' => ']',
  '<' => '>',
  }
  POINTS = {
    '}' => 1197,
    ']' => 57,
    '>' => 25137,
    ')' => 3
  }
  MORE_POINTS = {
    '}' => 3,
    ']' => 2,
    '>' => 4,
    ')' => 1
  }

  def initialize(char)
    @d = char
  end

  def opening?
    MAPPING.keys.include?(@d)
  end

  def closing?
    MAPPING.values.include?(@d)
  end

  def inverse
    MAPPING[@d] || MAPPING.invert.fetch(@d)
  end

  def to_i
    POINTS[@d]
  end

  def to_f
    MORE_POINTS[@d]
  end
end

# require 'byebug'

def corrupt?(line)
  chunk = []
  illegal_characters = []
  line.split('').map do |char|
    char = Bracket.new(char)

    if char.opening?
      chunk.push(char)
    elsif char.closing?
      unless chunk.pop() == char.inverse
        illegal_characters << char
      end
    else
      raise "unknown input"
    end
  end
  
  illegal_characters.size > 0
end

def autocomplete(line)
  chunk = []
  line.split('').map do |char|
    char = Bracket.new(char)

    if char.opening?
      chunk.push(char)
    elsif char.closing?
        yield chunk
      chunk.pop()
    else
      raise "unknown input"
    end
  end
  chunk.reverse.map(&:inverse)
end

def score_autocomplete(chars)
    chars.reduce(0) do |memo, chars|
        memo * 5 + chars.to_f
    end
end

scores = lines.map do |line|
  next if corrupt?(line)
  score_autocomplete(autocomplete(line))
end.compact.sort
puts scores[(scores.size-1)/2]

# puts "Answer: #{illegal_characters.reduce(0) { |memo, char| memo + char.to_i}}"