require 'byebug'
class Board
  def initialize(file)
    content = File.read(file).split("\n")
    @size, @raw_commands = content[0].to_i, content[2..-1]
    @orientation = 0
    @board_array = @size.times.map { ['.'] * @size }
    init_position
    parse_commands
    execute_commands
  end

  def parse_commands
    @commands = []
    @raw_commands.each do |raw_command|
      if raw_command =~ /REPEAT/
        ary = raw_command.split
        @commands << (ary[3..-2].each_slice(2).to_a.map{|c| c.join(' ')} * ary[1].to_i)
        @commands.flatten!
      else
        @commands << raw_command
      end
    end
  end

  def to_file(file)
    File.open(file, 'w') do |f|
      f.write @board_array.dup.map{|row| row.join(' ')}.join("\n")
    end
  end

  def execute_commands
    @commands.each do |command|
      direction, extent = command.split
      if %w(FD BK).include?(direction)
        extent.to_i.times { move(direction) }
      elsif %w(LT RT).include?(direction)
        turn(direction, extent.to_i)
      end
    end
  end

  def turn(direction, rotation)
    if direction == 'RT'
      @orientation = (@orientation + rotation) % 360
    elsif direction == 'LT'
      @orientation = (@orientation - rotation) % 360
    end
  end

  def move(direction)
    position = @orientation
    position = (position + 180) % 360 if direction == 'BK'
    case position
    when 0
      @position[:row] -= 1
    when 45
      @position[:row] -=1
      @position[:column] += 1
    when 90
      @position[:column] += 1
    when 135
      @position[:row] += 1
      @position[:column] += 1
    when 180
      @position[:row] += 1
    when 225
      @position[:row] += 1
      @position[:column] -= 1
    when 270
      @position[:column] -= 1
    when 315
      @position[:row] -= 1
      @position[:column] -= 1
    end
    @board_array[@position[:row]][@position[:column]] = 'X'
  end

  private
  def init_position
    center = @board_array.size / 2
    @position = {row: center, column: center}
    @board_array[center][center] = 'X'
  end
end

if $0 == __FILE__
  Board.new(ARGV[0]).to_file('my_output.txt')
else
  describe Board do
    it 'should create a board that matches the solution' do
      Board.new('complex.logo').to_file('my_output.txt')
      expect(File.read('my_output.txt')).to eq File.read('my_solution.txt')
    end
  end
end
