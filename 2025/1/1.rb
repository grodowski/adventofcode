pos = 50
count_is_zero = 0
time_crossed_zero = 0

File.readlines('input.txt').each do |line|
  dir = line[0]
  number = line[1..].to_i
  if pos == 0
    time_crossed_zero += number / 100
  else
    case dir
    when 'L'
      time_crossed_zero += (number + (100 - pos)) / 100
    when 'R'
      time_crossed_zero += (number + pos) / 100
    else
      raise
    end
  end

  case dir
  when 'L'
    pos = (pos - number) % 100
  when 'R'
    pos = (pos + number) % 100
  else
    raise
  end
  count_is_zero += 1 if pos == 0
end

puts count_is_zero
puts time_crossed_zero
