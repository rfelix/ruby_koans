require "greed_test_helper"

class PlayerTest < Test::Unit::TestCase
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
        def @player.roll_dice(n_dice = 5)
          @rolls ||= #{turn[:rolls].inspect}
          @rolls.shift
        end
      END_RUBY
      provide_input(("yes\n" * turn[:n]) + "no")
      assert_equal(turn[:score], @player.start_turn)
    end
  end
  
  must "only roll number of non-scoring dice after getting a score" do
    def @player.roll_dice(n_dice = 5)
      @rolls ||= [[5, 5, 1, 2, 3], [5, 2], [5], [1, 2, 3, 4, 3]]
      dice = @rolls.shift
      raise "n_dice(#{n_dice}) != from #{dice.length}" if n_dice != dice.length
      dice
    end
    provide_input("yes\nyes\nyes\nyes\nno")
    assert_equal(400, @player.start_turn)
  end
  
end