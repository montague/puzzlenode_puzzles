require 'byebug'
class ChessValidator

  attr_reader :board, :moves

  ROW_MAP = Hash[('1'..'8').to_a.reverse.zip(0..7)]
  COLUMN_MAP = Hash[('a'..'h').zip (0..7)]

  LEGAL = 'LEGAL'
  ILLEGAL = 'ILLEGAL'
  EMPTY = '--'
  WHITE = 'w'
  BLACK = 'b'

  def initialize(board_from_string)
    @board = parse_array_from_string(board_from_string)
  end

  def parse_and_set_moves_from_string(string)
    @moves = parse_array_from_string(string)
  end

  def at_position(position)
    row, column = translate_position(position)
    @board[row][column]
  end

  def validate_move(from, to)
    color, piece = at_position(from).split('')
    case piece
    when 'P' then validate_pawn_move(from,to,color)
    when 'R' then 'ROOK'
    when 'N' then 'KNIGHT'
    when 'B' then 'BISHOP'
    when 'Q' then 'QUEEN'
    when 'K' then 'KING'
    else
      raise "WTF??"
    end
  end

  private
  def translate_position(position)
    column, row = position.split('')
    [ROW_MAP[row].to_i, COLUMN_MAP[column].to_i]
  end

  def parse_array_from_string(string)
    string.split("\n").map do |row|
      row.split(' ')
    end
  end

  def validate_pawn_move(from, to, color)
    from_column, from_row = from.split('')
    to_column, to_row = to.split('')
    piece_at_to_position = at_position(to)

    # assumption:
    # black pawns start in row 7
    # white pawns start in rows 2

    if from_column != to_column && piece_at_to_position == EMPTY
      return ILLEGAL
    end

    return LEGAL

    # capturing
    #if from_column != to_column &&
      #at_position(to) != EMPTY
      #if color == WHITE && from_

    #end

    #if from_column == to_column
      #if color == 'b' && from_row == '7'
        #return LEGAL if %w(6 5).include?(to_row)
      #end

      #if color == 'w' && from_row == '2'
        #return LEGAL if %w(3 4).include?(to_row)
      #end
    #end
  end
end

