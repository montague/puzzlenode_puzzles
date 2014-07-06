require_relative 'chess_validator'

describe ChessValidator do

  before do
    @cv = ChessValidator.new(File.read('simple_board.txt'))
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

  describe '#piece_at_position' do
    it 'returns the correct piece at the given position' do
      expect(@cv.piece_at_position 'a2').to eq 'wP'
      expect(@cv.piece_at_position 'e4').to eq '--'
      expect(@cv.piece_at_position 'g8').to eq 'bN'
    end
  end


end
