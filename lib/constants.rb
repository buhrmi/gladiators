MAX_LEVEL = 99

EXP_TABLE = [].tap do |table|
  for level in 1..MAX_LEVEL
    table[level] = ((1.3 ** (level-1) - 1) * 40).round
  end
end
