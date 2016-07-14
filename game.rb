require_relative './node.rb'
require './constants.rb'
require 'byebug'

class Game
  attr_accessor :root

  def get_initial_user_move
    initial_position = get_user_input
    build_tree_from_initial_move(initial_position)
  end

  def build_tree_from_initial_move(initial_position)
    @root = Node.new(0, Constants.positions[initial_position], :white)
    @root.build_tree
  end

  def get_user_input
    puts "Choose a position: "
    gets.chomp.to_i
  end

  def display_initial_game_state
    board = (0..8).to_a.reverse
    puts
    puts "#{board[0]} #{board[1]} #{board[2]}"
    puts "#{board[3]} #{board[4]} #{board[5]}"
    puts "#{board[6]} #{board[7]} #{board[8]}"
    puts
  end

  def user_starts?
    puts "Do you want to have the first move?"
    loop do
      input = gets.chomp
      if input == 'y'
        return true
      else
        return false
      end
    end
  end

  def game_loop
    turn = 0;
    if user_starts?
      display_initial_game_state
      get_initial_user_move
    else
      build_tree_from_initial_move(0) # Just choose a border position as initial AI move
      turn += 1
    end
    until @root.won? || @root.game_over?
      turn += 1
      if turn % 2 == 0
        @root.display_board
        @root = get_user_next_move
      else
        @root = get_ai_next_move
      end
    end
    display_game_result
  end

  def display_game_result
    @root.display_board
    if @root.won?
      puts "#{@root.color} won"
    else
      puts "Draw."
    end
  end

  def get_ai_next_move
    # take a winning move if it's available
    @root.adjacent.each do |next_node|
      return next_node if next_node.path_to_victory
    end
    #do not choose a move that gives the next player a winning path
    @root.adjacent.each do |next_node|
      return next_node if next_node.adjacent.none? { |next_next_node| next_next_node.path_to_victory }
    end
  end

  def get_user_next_move
    next_moves = @root.next_moves
    loop do
      next_position = get_user_input
      next_node_idx = next_moves.find_index(next_position)
      return @root.adjacent[next_node_idx] if next_node_idx
    end
  end

  def calculate_all_possible_games
    (0..8).to_a.each do |initial_position|
      @root = Node.new(Constants.positions[initial_position], 0, :black)
      @root.build_tree
    end
    puts "#{@root.class.black_count} #{@root.class.white_count} #{@root.class.draw_count}"
  end

end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.game_loop
end
