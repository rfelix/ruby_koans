require "dice_set"
require "score"

InvalidNumberOfDice   = Class.new(StandardError)

class Player
  attr_reader :name
  
  def initialize(name, input = STDIN, output = STDOUT)
    @input = input
    @output = output
    @name = name
    @dice = DiceSet.new
    @score = Score.new
  end
  
  def roll_dice(n_dice = 5)
    raise InvalidNumberOfDice if n_dice < 1 || n_dice > 5
    @dice.roll(n_dice)
  end
  
  def start_turn
    turn_score = 0
    n_dice_roll = 5
    while true
      @output.puts "#{@name}: Roll?"
      roll_again = roll?(@input.gets.chomp)
      break if !roll_again
      if roll_again.nil?
        @output.puts "Unknown reply. Accepted answers: y(es) or n(o)"
        next
      end
      dice_roll = roll_dice(n_dice_roll)
      dice_score = @score.calculate(dice_roll)
      turn_score += dice_score
      n_dice_roll = @score.non_scoring_dice.length
      n_dice_roll = 5 if n_dice_roll.zero?
      @output.puts "Rolled #{dice_score}, with a total of #{turn_score}"
      if turn_score > 0 && dice_score == 0
        turn_score = 0
        @output.puts "Ouch, you were too greedy in this turn."
        break
      end
    end
    
    turn_score
  end
  
  def roll?(response)
    case response
    when /^y(es)?$/i
      true
    when /^no?$/i
      false
    end
  end
end