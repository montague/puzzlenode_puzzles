require_relative 'chess_validator'

describe ChessValidator do

  context 'basic board stuff' do

    before do
      @cv = ChessValidator.new(File.read 'simple_board.txt')
      @cv.parse_and_set_moves_from_string(File.read 'simple_moves.txt')
    end

    describe '#new' do
      it 'sets the board correctly' do
        expect(@cv.board).to match_array [
          %w(bR bN bB bQ bK bB bN bR),
          %w(bP bP bP bP bP bP bP bP),
          %w(-- -- -- -- -- -- -- --),
          %w(-- -- -- -- -- -- -- --),
          %w(-- -- -- -- -- -- -- --),
          %w(-- -- -- -- -- -- -- --),
          %w(wP wP wP wP wP wP wP wP),
          %w(wR wN wB wQ wK wB wN wR)
        ]
      end
    end

    describe '#at_position' do
      it 'returns the correct piece at the given position' do
        expect(@cv.at_position 'a2').to eq 'wP'
        expect(@cv.at_position 'e4').to eq '--'
        expect(@cv.at_position 'g8').to eq 'bN'
      end
    end

    describe '#parse_and_set_moves' do
      it 'populates a list of moves' do
        expect(@cv.moves).to match_array [
          %w(a2 a3),
          %w(a2 a4),
          %w(a2 a5),
          %w(a7 a6),
          %w(a7 a5),
          %w(a7 a4),
          %w(a7 b6),
          %w(b8 a6),
          %w(b8 c6),
          %w(b8 d7),
          %w(e2 e3),
          %w(e3 e2)
        ]
      end
    end
  end

  describe '#validate_move' do
    before do 
      @cv = ChessValidator.new(File.read 'complex_board.txt')
      #   a  b  c  d  e  f  g  h
      # 8 bK -- -- -- -- bB -- --
      # 7 -- -- -- -- -- bP -- --
      # 6 -- bP wR -- wB -- bN --
      # 5 wN -- bP bR -- -- -- wP
      # 4 -- -- -- -- wK wQ -- wP
      # 3 wR -- bB wN wP -- -- --
      # 2 -- wP bQ -- -- wP -- --
      # 1 -- -- -- -- -- wB -- --
    end

    it 'validates a pawn move correctly', focus: true do
      # one space forward
      expect(@cv.validate_move 'b2','b3').to eq 'LEGAL'
      # two spaces forward as first move
      expect(@cv.validate_move 'b2','b4').to eq 'LEGAL'
      # capture
      expect(@cv.validate_move 'b2','c3').to eq 'LEGAL'

      # two spaces forwad after first move
      expect(@cv.validate_move 'b6','b4').to eq 'ILLEGAL'
      # one space backward
      expect(@cv.validate_move 'b6','b7').to eq 'ILLEGAL'
      # one space forward to occupied space
      expect(@cv.validate_move 'h5','h4').to eq 'ILLEGAL'
    end

    it 'validates a rook move correctly'

    it 'validates a knight move correctly'

    it 'validates a bishop move correctly'

    it 'validates a queen move correctly'

    it 'validates a king move correctly'
  end

end
