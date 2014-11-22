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

  def piece_in_path?(from, to)
    # does not include starting point or ending point
    from_row, from_column = translate_position(from)
    to_row, to_column = translate_position(to)
    # vertical
    # horizontal
    # diagonal

    # vertical
    if from_column == to_column
      start = [from_row, to_row].min + 1
      finish = [from_row, to_row].max - 1
      (start..finish).each do |row_index|
        position = untranslate_position(row_index, from_column)
        if at_position(position) != EMPTY
          return true
        end
      end
    end
    return false
  end

  private

  # takes "a8" => [0,0]
  def translate_position(position)
    column, row = position.split('')
    [ROW_MAP[row].to_i, COLUMN_MAP[column].to_i]
  end

  # takes [0,0] => "a8"
  def untranslate_position(row, column)
    "#{COLUMN_MAP.invert[column]}#{ROW_MAP.invert[row]}"
  end

  def parse_array_from_string(string)
    string.split("\n").map do |row|
      row.split(' ')
    end
  end


  def validate_pawn_move(from, to, color)
    from_row, from_column = translate_position(from)
    to_row, to_column = translate_position(to)
    piece_at_to_position = at_position(to)
    # assumption:
    # black pawns start in row 1
    # white pawns start in row 6


    # cannot move two spaces forward after first move
    if color == BLACK
      if from_row > 1 && (to_row - from_row) > 1
        return ILLEGAL
      end
    else
      if from_row < 6 && (from_row - to_row) > 1
        return ILLEGAL
      end
    end

    # cannot move diagonally unless capturing
    if from_column != to_column && piece_at_to_position == EMPTY
      return ILLEGAL
    end

    # cannot move backward
    if color == BLACK && (to_row < from_row)
      return ILLEGAL
    elsif color == WHITE && (to_row > from_row)
      return ILLEGAL
    end

    # cannot move forward into or over occupied space
    if piece_at_to_position != EMPTY && from_column == to_column
      if color == BLACK && (from_row < to_row)
        return ILLEGAL
      elsif color == WHITE && (from_row > to_row)
        return ILLEGAL
      end
    end

    return LEGAL

    #
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

