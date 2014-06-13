require 'byebug'
class LogoFile
  attr_reader :size, :instructions

  def initialize(file)
    content = File.read(ARGV[0]).split("\n")
    @size = content[0].to_i
    @instructions = content[2..-1]
  end

  def to_s
    "#{size}\n#{instructions.join("\n")}"
  end
end

class Board
  attr_reader :size

  def initialize(logo_file)
    @size = logo_file.size
    @board_array = @size.times.map do
      ['.'] * @size
    end
    center_x!
  end

  private

  def to_s
    @board_array.dup.map{|row| row.join(' ')}.join("\n")
  end

  def center_x!
    center = @board_array.size / 2
    @board_array[center][center] = 'X'
  end
end

l = LogoFile.new(ARGV[0])
puts l
board = Board.new(l)
puts board
