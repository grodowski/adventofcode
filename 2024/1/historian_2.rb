# --- Part Two ---

# Your analysis only confirmed what everyone feared: the two lists of location IDs are indeed very different.

# Or are they?

# The Historians can't agree on which group made the mistakes or how to read most of the Chief's handwriting, but in the commotion you notice an interesting detail: a lot of location IDs appear in both lists! Maybe the other numbers aren't location IDs at all but rather misinterpreted handwriting.

# This time, you'll need to figure out exactly how often each number from the left list appears in the right list. Calculate a total similarity score by adding up each number in the left list after multiplying it by the number of times that number appears in the right list.

# Here are the same example lists again:

# 3   4
# 4   3
# 2   5
# 1   3
# 3   9
# 3   3
# For these example lists, here is the process of finding the similarity score:

# The first number in the left list is 3. It appears in the right list three times, so the similarity score increases by 3 * 3 = 9.
# The second number in the left list is 4. It appears in the right list once, so the similarity score increases by 4 * 1 = 4.
# The third number in the left list is 2. It does not appear in the right list, so the similarity score does not increase (2 * 0 = 0).
# The fourth number, 1, also does not appear in the right list.
# The fifth number, 3, appears in the right list three times; the similarity score increases by 9.
# The last number, 3, appears in the right list three times; the similarity score again increases by 9.
# So, for these example lists, the similarity score at the end of this process is 31 (9 + 4 + 0 + 0 + 9 + 9).

# Once again consider your left and right lists. What is their similarity score?

require "csv"

def parse_input(file_path)
  left_numbers = []
  right_numbers = []

  CSV.foreach(file_path, col_sep: "\s\s\s").each do |left, right|
    left_numbers << left.to_i
    right_numbers << right.to_i
  end

  [left_numbers, right_numbers]
end

def calculate_similarity_score(left_numbers, right_numbers)
  left_numbers.reduce(0) do |total_score, num|
    appearances = right_numbers.count(num)
    total_score += num * appearances
  end
end

# Read and parse the input
left_numbers, right_numbers = parse_input('input_1.csv')

# Calculate and print the similarity score
similarity_score = calculate_similarity_score(left_numbers, right_numbers)
puts "The similarity score is: #{similarity_score}"
