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
  end
  
  def roll_dice(n_dice = 5)
    raise InvalidNumberOfDice if n_dice < 1 || n_dice > 5
    @dice.roll(n_dice)
  end
  
  def start_turn
    turn_score = 0
    while true
      @output.puts "#{@name}: Roll?"
      roll_again = roll?(@input.gets.chomp)
      break if !roll_again
      if roll_again.nil?
        @output.puts "Unknown reply. Accepted answers: y(es) or n(o)"
        next
      end
      dice_roll = roll_dice()
      dice_score = score(dice_roll)
      turn_score += dice_score
      return 0 if turn_score > 0 && dice_score == 0
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