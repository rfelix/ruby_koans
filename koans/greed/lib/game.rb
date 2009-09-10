require "player"

WrongNumberOfPlayers  = Class.new(StandardError)

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