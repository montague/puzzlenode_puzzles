require_relative 'stacker'

if $0 == __FILE__
  puts "soon..."
else
  describe Stacker do
    it 'creates the correct output' do
      input_file = 'sample.stack'
      output_file = 'my_sample_output.txt'
      interpreter = Stacker::Interpreter.new
      interpreter.execute_file(input_file)
      interpreter.dump_stack_to_file(output_file)
      expect(File.read output_file).to eq File.read('sample_output.txt')
    end
  end
end
