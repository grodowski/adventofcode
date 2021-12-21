
Player = Struct.new(:score, :position, :name)

positions = (1..10).cycle

players = []
players << Player.new(0, 7, 1)
players << Player.new(0, 5, 2)
cycle_players = players.cycle
iter = 0
loop do
    iter += 1
    current_player = cycle_players.next

    move = dice.next + dice.next + dice.next
    current_player.position = positions.take(current_player.position + move).last
    current_player.score += current_player.position

    break if current_player.score >= 21
end

puts players, iter