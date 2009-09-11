#!/usr/bin/env ruby -wKU

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
require 'game'

puts "How many players?"
n = gets.chomp.to_i

game = Game.new
game.start(n)