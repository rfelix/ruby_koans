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

   must "circulate player turns in round robin fashion" do
     provide_input "P1\nP2\nP3"
     order = []
     @game.initialize_players(3)
     6.times { order << @game.next_player }
     assert_equal(@game.players + @game.players, order)
   end
   
   must "start keeping player score after 1st turn of 300 points" do
      provide_input "P1\nP2"
      @game.initialize_players(2)
      @game.players.each do |p|
        p.instance_eval do
          def start_turn
            @@turn_scores ||= [50, 100, 300, 299, 100, 300]
            @@turn_scores.shift
          end
        end
      end
      6.times do
        p = @game.next_player
        @game.count_player_score(p, p.start_turn)
      end
      assert_equal(@game.scores[@game.players[0]], 400)
      assert_equal(@game.scores[@game.players[1]], 300)
   end
   
   must "announce winner when player reaches 3000 points" do
     provide_input "P1\nP2\n"
     @game.initialize_players(2)
     @game.players.each do |p|
       p.instance_eval do
         def start_turn
           3000
         end
       end
     end
     p = @game.next_player
     assert_equal(3000, @game.count_player_score(p, p.start_turn))
     assert @game.winner?(p)
   end
end
  
  