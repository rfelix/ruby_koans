require "player"

WrongNumberOfPlayers  = Class.new(StandardError)

class Game
  attr_reader :players
  attr_reader :scores
  
  def initialize(input = STDIN, output = STDOUT)
    @input = input
    @output = output
    @players = []
    @player_turn = 0
    @scores = {}
  end
  
  def initialize_players(n_players)
    raise WrongNumberOfPlayers if n_players < 2
    1.upto(n_players) do |n|
      @output.puts "What's your name Player #{n}?"
      name = @input.gets.chomp
      player = Player.new(name, @input, @output)
      @players << player
      @scores[player] = 0
    end
  end
  
  def start(n_players)
    initialize_players n_players
    while true
      player = next_player
      score = player.start_turn
      count_player_score(player, score)
      if winner? player
        @output.puts "Congratulations!! #{player.name} is the WINNER!"
        break
      end
    end
  end
  
  def next_player
    @player_turn = 0 if @player_turn >= @players.length
    result = @players[@player_turn]
    @player_turn += 1
    result
  end
  
  def count_player_score(player, score)
    before = @scores[player]
    if @scores[player] == 0 && score >= 300 
      @output.puts "#{player.name} is now in the Game, starting with #{score} points"
      @scores[player] = score
    elsif @scores[player] >= 300
      @scores[player] += score
      @output.puts "#{player.name}'s current score = #{@scores[player]}"
    end
  end
  
  def winner?(player)
    @scores[player] >= 3000
  end
end