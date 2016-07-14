module Constants
  @positions = {}
  (0..8).to_a.each do |position|
    @positions[position] = 2**position
  end

  @winning_positions = ["111000000",
                       "000111000",
                       "000000111",
                       "100100100",
                       "010010010",
                       "001001001",
                       "100010001",
                       "001010100"].map { |str| str.to_i(2)}

  def self.positions
    return @positions
  end

  def self.winning_positions
    @winning_positions
  end
end
