require_relative 'chess_validator'

if $1 == __FILE__
  puts 'not ready yet...'
else
  require 'rspec'
  describe Board do
    it 'makes a thing' do
      expect(Board.new).to_not be_nil
    end
  end
end
