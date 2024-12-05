# --- Day 4: Ceres Search ---
# "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

# As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

# This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

# ..X...
# .SAMX.
# .A..A.
# XMAS.S
# .X....
# The actual word search will be full of letters instead. For example:

# MMMSXXMASM
# MSAMXMSMSA
# AMXSXMAAMM
# MSAMASMSMX
# XMASAMXAMM
# XXAMMXXAMA
# SMSMSASXSS
# SAXAMASAAA
# MAMMMXMMMM
# MXMXAXMASX
# In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

# ....XXMAS.
# .SAMXMS...
# ...S..A...
# ..A.A.MS.X
# XMASAMX.MM
# X.....XA.A
# S.S.S.S.SS
# .A.A.A.A.A
# ..M.M.M.MM
# .X.X.XMASX
# Take a look at the little Elf's word search. How many times does XMAS appear?

def count_xmas(grid)
  height = grid.length
  width = grid[0].length
  count = 0

  # Check all possible starting positions
  (0...height).each do |row|
    (0...width).each do |col|
      # Check horizontal right
      if col <= width - 4 && 
         grid[row][col,4] == "XMAS"
        count += 1
      end

      # Check horizontal left
      if col >= 3 && 
         grid[row][col-3..col].reverse == "XMAS"
        count += 1
      end

      # Check vertical down
      if row <= height - 4 && 
         grid[row][col] == "X" &&
         grid[row+1][col] == "M" &&
         grid[row+2][col] == "A" &&
         grid[row+3][col] == "S"
        count += 1
      end

      # Check vertical up
      if row >= 3 &&
         grid[row][col] == "X" &&
         grid[row-1][col] == "M" &&
         grid[row-2][col] == "A" &&
         grid[row-3][col] == "S"
        count += 1
      end

      # Check diagonal down-right
      if row <= height - 4 && col <= width - 4 &&
         grid[row][col] == "X" &&
         grid[row+1][col+1] == "M" &&
         grid[row+2][col+2] == "A" &&
         grid[row+3][col+3] == "S"
        count += 1
      end

      # Check diagonal down-left
      if row <= height - 4 && col >= 3 &&
         grid[row][col] == "X" &&
         grid[row+1][col-1] == "M" &&
         grid[row+2][col-2] == "A" &&
         grid[row+3][col-3] == "S"
        count += 1
      end

      # Check diagonal up-right
      if row >= 3 && col <= width - 4 &&
         grid[row][col] == "X" &&
         grid[row-1][col+1] == "M" &&
         grid[row-2][col+2] == "A" &&
         grid[row-3][col+3] == "S"
        count += 1
      end

      # Check diagonal up-left
      if row >= 3 && col >= 3 &&
         grid[row][col] == "X" &&
         grid[row-1][col-1] == "M" &&
         grid[row-2][col-2] == "A" &&
         grid[row-3][col-3] == "S"
        count += 1
      end
    end
  end

  count
end

# Read input
input = File.read('input.txt').split("\n")
puts count_xmas(input)

# Part two
# --- Part Two ---
# The Elf looks quizzically at you. Did you misunderstand the assignment?

# Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

# M.S
# .A.
# M.S
# Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

# Here's the same example from before, but this time all of the X-MASes have been kept instead:

# .M.S......
# ..A..MSMS.
# .M.S.MAA..
# ..A.ASMSM.
# .M.S.M....
# ..........
# S.S.S.S.S.
# .A.A.A.A..
# M.M.M.M.M.
# ..........
# In this example, an X-MAS appears 9 times.

# Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
def count_xmas_part2(grid)
  count = 0
  height = grid.length
  width = grid[0].length

  # Iterate through each position in grid
  (1..height-2).each do |row|
    (1..width-2).each do |col|
      # Check for X pattern with MAS sequences
      if grid[row][col] == "A" && 
         # Upper left to lower right diagonal
         ((grid[row-1][col-1] == "M" && grid[row+1][col+1] == "S") ||
          (grid[row-1][col-1] == "S" && grid[row+1][col+1] == "M")) &&
         # Upper right to lower left diagonal  
         ((grid[row-1][col+1] == "M" && grid[row+1][col-1] == "S") ||
          (grid[row-1][col+1] == "S" && grid[row+1][col-1] == "M"))
        count += 1
      end
    end
  end

  count
end

puts count_xmas_part2(input)
