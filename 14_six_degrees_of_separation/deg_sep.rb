require 'strscan'
require 'byebug'
class DegSep
  attr_reader :connections

  def initialize
    @connections = Hash.new{ |h,k| h[k] = [] }
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
    @connections[speaker] << names.sort
  end
end

if $0 == __FILE__
  File.readlines('complex_input.txt').each do |line|
    speaker = DegSep.new.parse_speaker(line)
    if speaker.nil?
      raise 'OMG'
    else
      puts speaker
    end
  end
else
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
