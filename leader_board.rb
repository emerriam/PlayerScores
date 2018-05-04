#!/usr/bin/env ruby
require 'csv'
require 'byebug'
require 'test/unit'


class Player
	attr_accessor :name, :score
	
	def initialize(args={})
	  args.each do |key, value|
	    send("#{key}=", value)
	  end
	end

	def update_score(new_score)
		self.score = self.score.to_i + new_score.to_i
	end

	def to_s
		"#{self.name}: #{self.score}"
	end

	def <=>(other_player)
		self.score <=> other_player.score
	end

end

class PlayerCollection

	include Enumerable
	attr_accessor :players

  def initialize(*input)
  	@players = parse_players(input)
  end

  def each
  	@players.map{|player| yield player}
  end

  def print_players
		players.each do |player|
			print "#{player}\n"
		end
  end

  def self.load_from_file(filename)
		CSV.read(filename)
  end

	private

  def parse_players(players)
  	temp = []
  	players.each do |p|
  		p.each do |pc|
  			temp << Player.new(name: pc[0], score: pc[1])
  		end
  	end
  	return temp
  end
end

# load in a new collection of players by file name
file = ARGV[0]
pc = PlayerCollection.new(CSV.read(file))
pc.print_players

# Test module, usually would be in another file
class PlayerTest < Test::Unit::TestCase

  def setup
    @player1 = Player.new(name: "Test", score: 5)
    @player2 = Player.new(name: "Bill", score: 5)
  end

  def test_player_initialization
  	assert_equal(@player1.name, "Test")
		assert_equal(@player1.score, 5)
  end

  def test_player_update_score_positive
  	@player1.update_score(3)
  	assert_equal(@player1.score, 8)
  end

  def test_player_update_score_negative
  	@player1.update_score(-12)
  	assert_equal(@player1.score, -7)
  end

  def test_player_to_s
  	assert_equal(@player2.to_s, "Bill: 5")
  end

end