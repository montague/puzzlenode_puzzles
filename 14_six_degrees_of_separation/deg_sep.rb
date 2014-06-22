require 'strscan'
require 'byebug'
class DegSep
  attr_reader :connections

  def initialize
    @connections = Hash.new{ |h,k| h[k] = [] }
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
    @connections.dup.each do |speaker, names|
      names[0].each do |name|
        next if @connections[name][0].nil?
        unless @connections[name][0].include?(speaker)
          @connections[speaker][0].delete(name)
          if @connections[speaker][0].empty?
            @connections[speaker].pop
          end
        end
      end
    end
  end

  def find_all_connections
    @connections.keys.dup.each do |speaker|
      find_mutual_connections_for(speaker)
    end
  end

  def find_mutual_connections_for(speaker, degree=1)
    return if @connections[speaker].empty?
    @connections[speaker][degree] ||= []
    @connections[speaker][degree - 1].each do |name|
      next if @connections[name][0].nil?
      @connections[name][0].each do |new_name|
        next if @connections[speaker].flatten.include?(new_name)
        next if new_name == speaker
        (@connections[speaker][degree] << new_name).flatten!
        @connections[speaker][degree].sort!
      end
    end
    if @connections[speaker][degree].empty?
      @connections[speaker].pop
      return
    else
      find_mutual_connections_for(speaker, degree + 1)
    end
  end

  def parse(str)
    scanner = StringScanner.new(str)
    speaker = scanner.scan_until(/:/).chop
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
    end
  end

  def to_file(file)
    str = ""
    @connections.keys.sort.each do |speaker|
      names_array = @connections[speaker]
      str << "#{speaker}\n"
      names_array.each do |names|
        str << "#{names.join(', ')}\n"
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
    before do
      @d = DegSep.new
      @d.parse_from_file('custom_input.txt')
    end

    describe 'run' do
      it 'works' do
        File.unlink('my_output.txt') if File.exist?('my_output.txt')
        d = DegSep.new
        d.run('custom_input.txt', 'my_output.txt')

        expect(File.read('my_output.txt')).to eq File.read('custom_output.txt')
      end
    end

    describe '#to_file' do
      it 'works' do
        @d.find_all_connections
        @d.to_file('my_output.txt')

        expect(File.read('my_output.txt')).to eq File.read('custom_output.txt')
      end
    end

    describe '#find_all_connections' do
      it 'works' do
        @d.find_all_connections

        expect(@d.connections['alberta']).to match_array [
          ['bob','christie'],['duncan','emily'],['farid']
        ]
        expect(@d.connections['bob']).to match_array [
          ['alberta','christie', 'duncan'],['emily','farid']
        ]
      end
    end

    describe '#find_mutual_connections_for' do
      it 'works for alberta' do
        @d.find_mutual_connections_for('alberta')
        alberta_conns = @d.connections['alberta']

        expect(alberta_conns).to match_array [
          ['bob','christie'],['duncan','emily'],['farid']
        ]
      end

      it 'works for bob' do
        @d.find_mutual_connections_for('bob')
        bob_conns = @d.connections['bob']

        expect(bob_conns).to match_array [
          ['alberta','christie', 'duncan'],['emily','farid']
        ]
      end

      it 'works for omg' do
        @d.find_mutual_connections_for('omg')
        omg_conns = @d.connections['omg']

        expect(omg_conns).to be_empty
      end
    end

    describe '#parse_from_file' do
      it 'parses speakers' do
        expect(@d.connections.keys.sort).to match_array [
          'alberta', 'bob', 'christie', 'duncan', 'emily', 'farid', 'omg'
        ]
      end

      it 'parses names' do
        expect(@d.connections['alberta']).to match_array [%w(bob christie)]
        expect(@d.connections['bob']).to match_array [%w(alberta christie duncan)]
        expect(@d.connections['christie']).to match_array [%w(alberta bob emily)]
        expect(@d.connections['duncan']).to match_array [%w(bob emily farid)]
        expect(@d.connections['emily']).to match_array [%w(christie duncan)]
        expect(@d.connections['farid']).to match_array [%w(duncan)]
      end
    end
  end
end
