class Game
  def initialize
    @board = Array.new(9)
    @turn = 0
  end

  def game_loop
     loop do
      current_player = turn % 2
      puts "Position: "
      loop do
        position = gets.chomp.to_i
        break if !@board[position].nil?
      end
      @board[position] = current_player
      break if won?(current_player)
    end
  end

  def won?(player)
    winning_positions = [[0,1,2], [3,4,5], [6,7,8], [0, 4, 8], [6, 4, 2]]
    winning_positions.each do |p1, p2, p3|
      return true if [@board[p1], @board[p2], @board[p3]].all { |el| el == player }
    end
    false
  end

  def display_board
    3.times { |i| puts "#{@board[3*i + 0]} #{@board[3*i + 1]} #{@board[3*i + 2]}" }
  end
end
