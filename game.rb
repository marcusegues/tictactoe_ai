require_relative './node.rb'
require './constants.rb'
require 'byebug'

class Game
  attr_accessor :root

  def game_loop
    initial_position = gets.chomp.to_i
    @root = Node.new(Constants.positions[initial_position], 0, :black)
    @root.build_tree
    # puts "#{@root.class.black_count} #{@root.class.white_count} #{@root.class.draw_count}"
  end
end

# unless $PROGRAM_NAME == __FILE__
#   game = Game.new
#   game.game_loop
# end
