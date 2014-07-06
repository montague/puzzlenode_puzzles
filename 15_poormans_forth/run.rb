require_relative 'stacker'

if $0 == __FILE__
  input_file = 'challenge.stack'
  output_file = 'my_challenge_output.txt'
  Stacker::Interpreter.new.tap do |interpreter|
    interpreter.execute_file(input_file)
    interpreter.dump_stack_to_file(output_file)
  end
else
  describe Stacker do
    it 'creates the correct output' do
      input_file = 'challenge.stack'
      output_file = 'my_challenge_output.txt'
      interpreter = Stacker::Interpreter.new
      interpreter.execute_file(input_file)
      interpreter.dump_stack_to_file(output_file)
      expect(File.read output_file).to eq File.read('my_challenge_solution_output.txt')
    end
  end
end
