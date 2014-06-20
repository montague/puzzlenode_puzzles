require 'byebug'
class Cracker
  ALPHABET = ('A'..'Z').to_a

  def initialize(file, keyword)
    lines = File.readlines(file)
    @keyword_array = keyword.split('')
    @keyword_length = @keyword_array.size
    @encrypted_lines = lines[2..-1].map!(&:chomp)
    @rotate_map = @keyword_array.map do |letter|
      ALPHABET.rotate(ALPHABET.index(letter))
    end
  end

  def crack!
    @current_rotate_map_index = 0
    @translated_lines = @encrypted_lines.map do |encrypted_line|
      encrypted_line.split('').map do |encrypted_letter|
        translated_index = @rotate_map[@current_rotate_map_index].index(encrypted_letter)
        if translated_index.nil?
          encrypted_letter
        else
          @current_rotate_map_index = (@current_rotate_map_index + 1) % @keyword_length
          translated_letter = ALPHABET[translated_index]
        end
      end
    end
  end

  def to_file(file)
    File.open(file, 'w') do |f|
      f.write(@translated_lines.map do |line|
        line.join
      end.join("\n"))
    end
  end

  def self.test(word)
    26.times do |i|
      letter_map = ALPHABET.rotate(i)
      letters = word.split('').map do |letter|
        ALPHABET[letter_map.index(letter)]
      end
      puts letters.join
    end
  end
end


if $0 == __FILE__
  c = Cracker.new(ARGV[0], 'DANGEROUS')
  c.crack!
  c.to_file('my_complex_out.txt')
  #puts Cracker.test("UREXVIFLJ")
else
  describe Cracker do
    it "works" do
      c = Cracker.new('simple_cipher.txt', 'GARDEN')
      c.crack!
      c.to_file 'my_simple_out.txt'
      expect(File.read('my_simple_out.txt')).to eq File.read('simple_out.txt')
    end
  end
end
