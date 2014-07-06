require_relative 'chess_validator'

if $0 == __FILE__
  puts 'not ready yet...'
else
  describe Board do
    it 'makes a thing' do
      expect(Board.new).to_not be_nil
    end
  end
end
