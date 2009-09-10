
class Score
  attr_reader :non_scoring_dice
  
  def initialize
    @non_scoring_dice = []
  end
  
  def calculate(dice)
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
    unless ones.nil?
      result += ones * 100 
      dice -= [1]
    end

    fives = dice.select { |i| i == 5 }.length 
    unless ones.nil?
      result += fives * 50 unless fives.nil?
      dice -= [5]
    end

    @non_scoring_dice = dice  
    result
  end
end