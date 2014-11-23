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

  describe 'with a complex bored' do
    before do
      @cv = ChessValidator.new(File.read 'test_complex_board.txt')
      #     0  1  2  3  4  5  6  7
      #     a  b  c  d  e  f  g  h
      # 0 8 bK -- -- -- -- bB -- --
      # 1 7 -- -- -- -- -- bP bP --
      # 2 6 -- bP wR -- wB -- bN --
      # 3 5 wN -- bP bR -- -- -- wP
      # 4 4 -- -- -- -- wK wQ -- wP
      # 5 3 wR -- bB wN wP -- -- --
      # 6 2 -- wP bQ wP -- wP -- --
      # 7 1 -- -- -- -- -- wB -- --
    end

    context '#piece_in_path?' do
      it 'detects a piece in a vertical path' do
        # down to up
        expect(@cv.piece_in_path?('c2', 'c4')).to eq true
        expect(@cv.piece_in_path?('c6', 'c8')).to eq false
        # up to down
        expect(@cv.piece_in_path?('d5', 'd1')).to eq true
        expect(@cv.piece_in_path?('a3', 'a1')).to eq false
      end

      it 'detects a piece in a horizontal path' do
        # left to right
        expect(@cv.piece_in_path?('a3', 'f3')).to eq true
        expect(@cv.piece_in_path?('a8', 'e8')).to eq false
        # right to left
        expect(@cv.piece_in_path?('c6', 'a6')).to eq true
        expect(@cv.piece_in_path?('e8', 'b8')).to eq false
      end

      it 'detects a piece in a diagonal path' do
        # up left to right
        expect(@cv.piece_in_path?('b3', 'e6')).to eq true
        expect(@cv.piece_in_path?('a2', 'c4')).to eq false
        # up right to left
        expect(@cv.piece_in_path?('g2', 'd5')).to eq true
        expect(@cv.piece_in_path?('d6', 'b8')).to eq false
        # down left to right
        expect(@cv.piece_in_path?('b3', 'd1')).to eq true
        expect(@cv.piece_in_path?('b8', 'd6')).to eq false
        # down right to left
        expect(@cv.piece_in_path?('h8', 'f6')).to eq true
        expect(@cv.piece_in_path?('g7', 'd4')).to eq false
      end
    end

    context 'validating pawn moves' do

      it 'allows one space forward' do
        # one space forward
        expect(@cv.validate_move 'b2','b3').to eq 'LEGAL'
      end

      it 'allows two spaces forward as first move' do
        # two spaces forward as first move (white)
        expect(@cv.validate_move 'b2','b4').to eq 'LEGAL'
        # two spaces forward as first move (black)
        expect(@cv.validate_move 'f7','f5').to eq 'LEGAL'
      end

      it 'allows capture' do
        # capture (white to black)
        expect(@cv.validate_move 'b2','c3').to eq 'LEGAL'
        # capture (black to white)
        expect(@cv.validate_move 'f7','e6').to eq 'LEGAL'
      end

      it 'does not allow diagonal without capturing' do
        # diagonal without capturing (white)
        expect(@cv.validate_move 'f2','g3').to eq 'ILLEGAL'
        # diagonal without capturing (black)
        expect(@cv.validate_move 'g7','h6').to eq 'ILLEGAL'
      end

      it 'does not allow two spaces or more after first move' do
        # two spaces forwad after first move (black)
        expect(@cv.validate_move 'b6','b4').to eq 'ILLEGAL'
        # three spaces forwad after first move (white)
        expect(@cv.validate_move 'h5','h8').to eq 'ILLEGAL'
      end

      it 'does not allow moving backward' do
        # one space backward (black)
        expect(@cv.validate_move 'g7','g8').to eq 'ILLEGAL'
        # three spaces backward (white)
        expect(@cv.validate_move 'h4','h1').to eq 'ILLEGAL'
      end

      it 'does not allow moving foward to occupied space' do
        # one space forward to occupied space (white)
        expect(@cv.validate_move 'h4','h5').to eq 'ILLEGAL'
        # one space forward to occupied space (black)
        expect(@cv.validate_move 'g7','g6').to eq 'ILLEGAL'
      end

      it 'does not allow jumping over other pieces' do
        # black
        expect(@cv.validate_move 'g7', 'g6').to eq 'ILLEGAL'
        # white
        expect(@cv.validate_move 'd2', 'd4').to eq 'ILLEGAL'
      end
    end

    it 'validates a rook move correctly'

    it 'validates a knight move correctly'

    it 'validates a bishop move correctly'

    it 'validates a queen move correctly'

    it 'validates a king move correctly'
  end

end
