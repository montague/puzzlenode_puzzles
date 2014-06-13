class LogoFile
  attr_reader :size, :commands

  def initialize(file)
    content = File.read(ARGV[0]).split("\n")
    @size = content[0].to_i
    @commands = content[2..-1]
  end

  def to_s
    "#{size}\n#{commands.join("\n")}"
  end
end

class Board
  COMMANDS = %w(FD RT LT BK REPEAT)

  attr_reader :size

  def initialize(logo_file)
    @size = logo_file.size
    @raw_commands = logo_file.commands
    @orientation = 0
    init_board
    init_position
    parse_commands
    execute_commands
  end

  def parse_commands
    @commands = []
    @raw_commands.each do |raw_command|
      if raw_command =~ /REPEAT/
        ary = raw_command.split
        times = ary[1].to_i
        # format is
        # REPEAT 2 [ RT 90 FD 15 ]
        to_repeat = ary[3..-2]
        parsed_commands_to_repeat = []
        while to_repeat.any?
          parsed_commands_to_repeat << "#{to_repeat.shift} #{to_repeat.shift}"
        end
        @commands << (parsed_commands_to_repeat * times)
        @commands.flatten!
      else
        @commands << raw_command
      end
    end
  end

  def to_file(file)
    File.open(file, 'w') do |f|
      f.write self
    end
  end

  def execute_commands
    @commands.each do |command|
      direction, extent = command.split
      if %w(FD BK).include?(direction)
        extent.to_i.times { move(direction) }
      elsif %w(LT RT).include?(direction)
        turn(direction, extent.to_i)
      else
        raise "Unknown direction: #{direction}"
      end
    end
  end

  def turn(direction, rotation)
    if direction == 'RT'
      @orientation = (@orientation + rotation) % 360
    elsif direction == 'LT'
      @orientation = (@orientation - rotation) % 360
    else
      raise "Unknown turn: #{direction}"
    end
  end

  # TODO clean this up
  def move(direction)
    if direction == 'FD'
      case @orientation
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
      else
        raise "Invalid orientation: #{@orientation}"
      end
    elsif direction == 'BK'
      case @orientation
      when 0
        @position[:row] += 1
      when 45
        @position[:row] +=1
        @position[:column] -= 1
      when 90
        @position[:column] -= 1
      when 135
        @position[:row] -= 1
        @position[:column] -= 1
      when 180
        @position[:row] -= 1
      when 225
        @position[:row] -= 1
        @position[:column] += 1
      when 270
        @position[:column] += 1
      when 315
        @position[:row] += 1
        @position[:column] += 1
      end
    else
      raise "Unknown move: #{direction}"
    end
    @board_array[@position[:row]][@position[:column]] = 'X'
  end

  private
  def init_board
    @board_array = @size.times.map do
      ['.'] * @size
    end
  end

  def init_position
    center = @board_array.size / 2
    @position = {row: center, column: center}
    @board_array[center][center] = 'X'
  end

  def to_s
    @board_array.dup.map{|row| row.join(' ')}.join("\n")
  end
end

l = LogoFile.new(ARGV[0])
puts l
board = Board.new(l)
puts board
board.to_file('my_output.txt')
