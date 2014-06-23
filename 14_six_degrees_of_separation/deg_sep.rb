require 'strscan'
require 'byebug'
class DegSep

  attr_reader :connections

  def initialize
    @connections = {}
  end

  def run(input_file, output_file)
    parse_from_file(input_file)
    find_all_connections
    to_file(output_file)
  end

  def parse_from_file(file)
    File.readlines(file).each do |line|
      parse(line)
    end
    prune_non_first_order_connections
  end

  def prune_non_first_order_connections
    @connections.keys.each do |speaker|
      speaker_connections = @connections[speaker][0]
      speaker_connections.dup.each do |name|
        if @connections[name].nil?
          speaker_connections.delete(name)
        elsif !@connections[name][0].include?(speaker)
          speaker_connections.delete(name)
        end
      end
    end
  end

  def parse(str)
    scanner = StringScanner.new(str)
    speaker = scanner.scan_until(/:/).chop
    @connections[speaker] ||= []
    names = []
    loop do
      break unless scanner.match?(/.*@/)
      scanner.scan_until(/@/)
      names << scanner.scan_until(/\W/).chop
    end
    if names.any?
      if @connections[speaker].empty?
        @connections[speaker][0] = []
      end
      (@connections[speaker][0] += names).sort!
      @connections[speaker][0].uniq!
    end
  end

  def find_all_connections
    @connections.keys.each do |speaker|
      find_mutual_connections_for(speaker)
    end
  end

  def find_mutual_connections_for(speaker, degree=1)
    @connections[speaker][degree] ||= []
    @connections[speaker][degree - 1].each do |name|
      @connections[name][0].each do |new_name|
        next if @connections[speaker].flatten.include?(new_name)
        next if new_name == speaker
        (@connections[speaker][degree] << new_name).sort!
      end
    end
    if @connections[speaker][degree].empty?
      @connections[speaker].pop
    else
      find_mutual_connections_for(speaker, degree + 1)
    end
  end

  def to_file(file)
    str = ""
    @connections.keys.sort.each do |speaker|
      names_array = @connections[speaker]
      str << "#{speaker}\n"
      names_array.each do |names|
        str << "#{names.join(', ')}\n" if names.any?
      end
      str << "\n"
    end
    str.chomp!
    File.open(file, 'w') do |f|
      f.write str
    end
  end
end

if $0 == __FILE__
  d = DegSep.new
  d.run("complex_input.txt", 'complex_output.txt')
else
  describe DegSep do
     describe 'run' do
       it 'works' do
         File.unlink('my_output.txt') if File.exist?('my_output.txt')
         d = DegSep.new
         d.run('custom_input.txt', 'my_output.txt')

         expect(File.read('my_output.txt')).to eq File.read('custom_output.txt')
       end
    end

    describe '#parse_from_file' do
      before do
        @d = DegSep.new
        @d.parse_from_file('custom_input.txt')
      end

      it 'parses speakers' do
        expect(@d.connections.keys.sort).to match_array [
          'alberta', 'bob', 'christie', 'duncan', 'emily', 'farid', 'omg'
        ]
      end

      it 'parses names',:focus do
        expect(@d.connections['alberta']).to match_array [%w(bob christie)]
        expect(@d.connections['bob']).to match_array [%w(alberta christie duncan)]
        expect(@d.connections['christie']).to match_array [%w(alberta bob emily)]
        expect(@d.connections['duncan']).to match_array [%w(bob emily farid)]
        expect(@d.connections['emily']).to match_array [%w(christie duncan)]
        expect(@d.connections['farid']).to match_array [%w(duncan)]
        expect(@d.connections['omg']).to match_array [[]]
      end
    end
  end
end
