require "greed_test_helper"

class GameTest < Test::Unit::TestCase
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