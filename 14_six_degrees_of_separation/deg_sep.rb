require 'strscan'
require 'byebug'
class DegSep
  attr_reader :connections

  def initialize
    @connections = Hash.new{ |h,k| h[k] = [] }
  end

  def parse_from_file(file)
    File.readlines(file).each do |line|
      parse(line)
    end
    reconcile_connections
  end

  def reconcile_connections
    @connections.dup.each do |speaker, names|
      names.each do |name|
        unless @connections[name].include?(speaker)
          @connections[speaker].delete(name)
        end
      end
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
    @connections[speaker] << [names.sort].flatten
  end
end

if $0 == __FILE__
  raise 'omg, not ready!!'
else
  describe DegSep, '#parse_from_file' do
    before do
      @d = DegSep.new
      @d.parse_from_file('sample_input.txt')
    end

    it 'parses speakers' do
      expect(@d.connections.keys.sort).to match_array [
        'alberta', 'bob', 'christie', 'duncan', 'emily', 'farid'
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

  describe DegSep, '#parse' do
    it "works on simple" do
      d = DegSep.new
      s = "alberta: @bob \"It is remarkable, the character of the pleasure we derive from the best books.\""
      d.parse(s)

      expect(d.connections.keys).to match_array ["alberta"]
      expect(d.connections['alberta'].first).to match_array ['bob']
    end

    it 'works on less complicated' do
      d = DegSep.new
      s = "daniella_hamill: @madelyn, @concepcion_hoppe: Power is in nature the essential measure  of right"
      d.parse(s)
      expect(d.connections.keys).to eq ["daniella_hamill"]
      expect(d.connections['daniella_hamill'].first).to match_array %w(concepcion_hoppe madelyn)
    end
  end
end
