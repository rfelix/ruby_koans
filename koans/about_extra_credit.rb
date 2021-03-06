# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

require 'test/unit'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'greed', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), 'greed', 'test')

%w[dice_set_test score_test player_test game_test].each do |test|
  require "greed/test/" + test
end 

