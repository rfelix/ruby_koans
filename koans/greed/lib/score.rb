def score(dice)
  result = 0
  dice.each do |n|
    set = dice.select { |i| i == n }
    if set.length >= 3
      result += 1000 if n == 1
      result += n * 100 if n != 1
      dice -= set[0..2]
      # Re-add the elements that weren't supposed to be removed
      dice += [n] * (set.length - 3)
    end
  end

  ones = dice.select { |i| i == 1 }.length 
  result += ones * 100 unless ones.nil?

  fives = dice.select { |i| i == 5 }.length 
  result += fives * 50 unless fives.nil?
  
  result
end