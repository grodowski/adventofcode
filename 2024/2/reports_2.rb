# The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.

# The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!

# Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

# More of the above example's reports are now safe:

# 7 6 4 2 1: Safe without removing any level.
# 1 2 7 8 9: Unsafe regardless of which level is removed.
# 9 7 6 2 1: Unsafe regardless of which level is removed.
# 1 3 2 4 5: Safe by removing the second level, 3.
# 8 6 4 4 1: Safe by removing the third level, 4.
# 1 3 6 7 9: Safe without removing any level.
# Thanks to the Problem Dampener, 4 reports are actually safe!

# Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?

# Note to self: tried out asking Cursor to early return inside safe_report? to speed things up, but it failed to achieve this. Moving on...

def safe_report?(report)
  diffs = report.each_cons(2).map { |a, b| b - a }
  return false if diffs.empty?
  
  # Check if all differences are positive (increasing) or all negative (decreasing)
  all_increasing = diffs.all? { |diff| diff > 0 && diff <= 3 && diff >= 1 }
  all_decreasing = diffs.all? { |diff| diff < 0 && diff >= -3 && diff <= -1 }
  
  all_increasing || all_decreasing
end

def safe_with_dampener?(report)
  return true if safe_report?(report)
  
  # Try removing each level one at a time
  report.length.times do |i|
    dampened_report = report[0...i] + report[i+1..]
    return true if safe_report?(dampened_report)
  end
  
  false
end

reports = File.readlines('input.txt').map { |line| line.split.map(&:to_i) }
puts reports.count { safe_with_dampener?(_1) }
