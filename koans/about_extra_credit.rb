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

WrongNumberOfPlayers = Class.new(StandardError)

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
  
  def roll_dice
    @dice.roll(6)
  end
  
  # TODO: Remove gets form @roll? and only have IO operations in start_turn
  
  def start_turn
    # while roll?
      # Add score
      # If score 0, return 0 for this turn
  end
  
  def roll?
    @output.puts "Roll? (y[es]/n[o])"
    case @input.gets
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
     
    must "roll 6 dices" do
      dice_roll = @player.roll_dice
      assert_equal 6, dice_roll.length
    end
    
    %w[y Y YeS YES yes].each do |yes|
      must "return true when user replies #{yes}" do
        provide_input(yes)
        assert @player.roll?, "#{yes.inspect} expected to be true"
      end
    end

    %w[n N no No nO].each do |no|
      must "return false when user replies #{no}" do
        provide_input(no)
        assert !@player.roll?, "#{no.inspect} expected to be false"
      end
    end
    
    %w[harhar Yippy sleeeeep].each do |bad|
      must "return nil because #{bad} is not a variant of 'yes' or 'no'" do
        provide_input(bad)
        assert_nil @player.roll?, "#{bad.inspect} expected to parse as nil"
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