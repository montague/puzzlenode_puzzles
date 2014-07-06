require 'byebug'
class ChessValidator

  attr_reader :board

  ROW_MAP = Hash[('1'..'8').to_a.reverse.zip(0..7)]
  COLUMN_MAP = Hash[('a'..'h').zip (0..7)]

  def initialize(board_from_string)
    parse_and_set_board_from_string(board_from_string)
  end

  def piece_at_position(position)
    column, row = position.split('')
    @board[ROW_MAP[row]][COLUMN_MAP[column]]
  end

  private
  def parse_and_set_board_from_string(string)
    @board = string.split("\n").map do |row|
      row.split(' ')
    end
  end
end

