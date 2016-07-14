require 'byebug'
require './constants.rb'

class Node
  @black_count = 0
  @white_count = 0
  @draw_count = 0

  class << self
    attr_accessor :black_count, :white_count, :draw_count
  end

  attr_accessor :black, :white, :path_to_victory, :adjacent, :color
  def initialize(black = 0, white = 0, color = :white, adjacent = [])
    @black = black
    @white = white
    @color = color
    @won = won?
    @adjacent = adjacent
  end

  def next_moves
    bits = ~(black | white)
    8.downto(0).select { |pos| pos unless bits[pos] == 0 }
    # https://calleerlandsson.com/2014/02/06/rubys-bitwise-operators/
  end

  def binary_representation(int)
    8.downto(0).map { |pos| int[pos] }.join
  end

  def display_board
    board = Array.new(9) {"_"}
    binary_representation(@black).split("").each_with_index do |el, i|
      board[i] = "x" if el == "1"
    end
    binary_representation(@white).split("").each_with_index do |el, i|
      board[i] = "o" if el == "1"
    end
    puts
    puts "#{board[0]} #{board[1]} #{board[2]}"
    puts "#{board[3]} #{board[4]} #{board[5]}"
    puts "#{board[6]} #{board[7]} #{board[8]}"
    puts
  end

  def build_tree
    # display_board
    paths_to_victory_on_next_current_player_move = nil
    unless @won || game_over?
      paths_to_victory_on_next_current_player_move = []
      next_moves.each do |move|
        new_node = Node.new(
          next_player_color == :black ? simulate_move(:black, Constants.positions[move]) : @black,
          next_player_color == :white ? simulate_move(:white, Constants.positions[move]) : @white,
          next_player_color
        )
        @adjacent << new_node
        paths_to_victory_on_next_current_player_move << new_node.build_tree
      end
    end

    if @won
      @path_to_victory = true
    else
      if paths_to_victory_on_next_current_player_move
        @path_to_victory = paths_to_victory_on_next_current_player_move.all?
      else
        @path_to_victory = false
      end
    end

    update_game_counts

    return @adjacent.any? {|node| node.path_to_victory}
  end

  def won?
    current_player_played = self.instance_variable_get("@#{@color}")
    Constants.winning_positions.each do |winning_position|
      return true if ((winning_position & current_player_played) == winning_position)
    end
    false
  end

  def game_over?
    !@won && next_moves.empty?
  end

  def simulate_move(color, move)
    played = self.instance_variable_get("@#{color}")
    played | move
  end

  def next_player_color
    return :white if @color == :black
    :black
  end

  def update_game_counts
    Node.black_count += 1 if (@won && (@color == :black))
    Node.white_count += 1 if (@won && (@color == :white))
    Node.draw_count += 1 if (!@won && game_over?)
  end
end
