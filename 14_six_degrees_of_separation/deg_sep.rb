class DegSep
  def parse_speaker(s)
    /\A(.*)?:/.match(s)[1]
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
  describe DegSep, '#parse_speaker' do
    it "works" do
      tweet = "alberta: @bob \"It is remarkable, the character of the pleasure we derive from the best books.\""

    end
  end
end
