# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

class DiceSet
  attr_reader :values
  def roll(n)
    @values = (1..n).map { rand(6) + 1 }
  end
end

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

WrongNumberOfPlayers  = Class.new(StandardError)
InvalidNumberOfDice   = Class.new(StandardError)

class Game
  attr_reader :players
  
  def initialize(input = STDIN, output = STDOUT)
    @input = input
    @output = output
    @players = []
  end
  
  def initialize_players(n_players)
    raise WrongNumberOfPlayers if n_players < 2
    1.upto(n_players) do |n|
      @output.puts "What's your name Player #{n}?"
      name = @input.gets.chomp
      @players << Player.new(name)
    end
  end
  
  def start(n_players)
    initialize_players n_players
  end
end

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

if __FILE__ == $PROGRAM_NAME
  require "test/unit"
  require "test_unit_extensions"
  require 'stringio'
  
  class TestPlayer < Test::Unit::TestCase
    include StringIOHelper
    
    def setup
      @input = StringIO.new
      @output = StringIO.new
      @player = Player.new("P", @input, @output)
    end
     
    must "be able to retrieve the player's name" do
      assert_equal("P", @player.name)
    end
     
    1.upto(5) do |i|
      must "roll #{i} dice" do
        dice_roll = @player.roll_dice(i)
        assert_equal i, dice_roll.length
      end
    end
    
    [-5,0,6].each do |i|
      must "raise error when rolling #{i} dice" do
        assert_raise(InvalidNumberOfDice) { @player.roll_dice(i) }
      end
    end
    
    %w[y Y YeS YES yes].each do |yes|
      must "return true when user replies #{yes}" do
        assert @player.roll?(yes), "#{yes.inspect} expected to be true"
      end
    end

    %w[n N no No nO].each do |no|
      must "return false when user replies #{no}" do
        assert !@player.roll?(no), "#{no.inspect} expected to be false"
      end
    end
    
    %w[harhar Yippy sleeeeep].each do |bad|
      must "return nil because #{bad} is not a variant of 'yes' or 'no'" do
        assert_nil @player.roll?(bad), "#{bad.inspect} expected to parse as nil"
      end
    end
    
    [
      { :n => 2, :score => 500, :rolls => [[5,1,3,4,1], [5,1,3,4,1]] },
      { :n => 2, :score => 50, :rolls => [[2,3,4,2,3], [2,5,3,4,2]] },
      { :n => 3, :score => 0, :rolls => [[2,3,4,2,3], [2,5,3,4,2], [2,3,4,2,3]] },
      { :n => 3, :score => 50, :rolls => [[2,3,4,2,3], [2,3,4,2,3], [2,5,3,4,2]] }
    ].each do |turn|
      must "must have score of #{turn[:score]} after #{turn[:n]} rolls" do
        eval <<-END_RUBY
          def @player.roll_dice
            @rolls ||= #{turn[:rolls].inspect}
            @rolls.shift
          end
        END_RUBY
        provide_input(("yes\n" * turn[:n]) + "no")
        assert_equal(turn[:score], @player.start_turn)
      end
    end
  end

  class TestGame < Test::Unit::TestCase
    include StringIOHelper
    
    def setup
      @input = StringIO.new
      @output = StringIO.new
      @game = Game.new(@input, @output)
    end
    
    must "raise error if number of players is less than 2" do
      assert_raise(WrongNumberOfPlayers) do
        @game.start(1)
      end
    end
    
    must "initialize 2 players and ask for their names" do
      provide_input "P1\nP2"
      @game.initialize_players(2)
      expect_output "What's your name Player 1?\nWhat's your name Player 2?\n"
      assert_equal 2, @game.players.size
    end
    
  end
end