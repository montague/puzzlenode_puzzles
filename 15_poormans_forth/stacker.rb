require 'byebug'
module Stacker

  class Interpreter

    attr_reader :stack

    def initialize
      @stack = []
      @if_blocks = []
      @current_block = []
      @times_block = []
      @procedures = {}
      @procedures_block = []
    end

    def execute_file(file)
      File.readlines(file).each do |command|
        execute(command)
      end
    end

    def dump_stack_to_file(file)
      File.open(file, 'w') do |f|
        until @stack.empty?
          f.puts @stack.pop.inspect
        end
      end
    end

    def execute(command)
      command = command.strip.chomp
      return unless command.length > 0
      if @times_block.any? && command != '/TIMES'
        @times_block.last[1].push(command)
        return
      end
      if @procedures_block.any? && command != '/PROCEDURE'
        @procedures[@procedures.keys.last].push(command)
        return
      end
      case command
      when 'ADD' then __execute('add')
      when 'SUBTRACT' then __execute('subtract')
      when 'MULTIPLY' then __execute('multiply')
      when 'DIVIDE' then __execute('divide')
      when 'MOD' then __execute('mod')
      when '<' then __execute('less_than')
      when '>' then __execute('greater_than')
      when '=' then __execute('equals')
      when 'IF' then execute_if
      when 'ELSE' then execute_else
      when 'THEN' then execute_then
      when 'TIMES' then __execute('begin_times')
      when '/TIMES' then __execute('end_times')
      when 'DUP' then __execute('dup')
      when 'SWAP' then __execute('swap')
      when 'DROP' then __execute('drop')
      when 'ROT' then __execute('rot')
      when /\APROCEDURE (\w+)\z/
        execute_procedure_start($1) if execute?
      when '/PROCEDURE' then __execute('procedure_end')
      else
        if execute?
          if @procedures.key?(command)
            procedure = @procedures[command]
            procedure.each do |command|
              execute(command)
            end
          else
            @stack.push(eval command)
          end
        end
      end
    end

    private
    def __execute(method)
      send("execute_#{method}") if execute?
    end

    def execute?
      @if_blocks == @current_block
    end

    def execute_procedure_start(name)
      @procedures[name] = []
      @procedures_block.push(:procedure)
    end

    def execute_procedure_end
      @procedures_block.pop
    end

    def execute_rot
      # ROT takes the third element on the stack and places it on the
      # top of the stack, pushing the first and second element downwards
      raise "Invalid operation: ROT on only #{@stack.size} elements" unless @stack.size >= 3
      @stack.push(@stack.slice!(-3))
    end

    def execute_drop
      @stack.pop
    end

    def execute_swap
      a,b = @stack.pop, @stack.pop
      @stack.push(*[a,b])
    end

    def execute_dup
      @stack.push(@stack.last)
    end

    def execute_begin_times
      iterations = @stack.pop
      @times_block.push([iterations, []])
    end

    def execute_end_times
      iterations, commands = @times_block.pop
      iterations.times do
        commands.each do |command|
          execute(command)
        end
      end
    end

    def execute_then
      @current_block.pop
      @if_blocks.pop
    end

    def execute_else
      @current_block.pop
      @current_block.push(:else)
    end

    def execute_if
      arg = if [:true,:false].include?(@stack.last)
              @stack.pop
            else
              :noop
            end
      @current_block.push(:if)
      if arg == :true
        @if_blocks.push(:if)
      elsif arg == :false
        @if_blocks.push(:else)
      else
        @if_blocks.push(:noop)
      end
    end

    def execute_equals
      execute_binary_predicate(:==)
    end

    def execute_greater_than
      execute_binary_predicate(:>)
    end

    def execute_less_than
      execute_binary_predicate(:<)
    end

    def execute_mod
      execute_binary_operation(:%)
    end

    def execute_divide
      execute_binary_operation(:/)
    end

    def execute_multiply
      execute_reduce(:*)
    end

    def execute_add
      execute_reduce(:+)
    end

    def execute_subtract
      execute_binary_operation(:-)
    end

    def execute_reduce(operator)
      @stack.push(binary_operands.reduce(&operator))
    end

    def execute_binary_predicate(operator)
      execute_binary_operation(operator) do |result|
        result.to_s.to_sym
      end
    end

    def execute_binary_operation(operator, &block)
      operands = binary_operands
      result = operands[1].send(operator, operands[0])
      result = yield(result) if block_given?
      @stack.push(result)
    end

    def binary_operands
      [@stack.pop, @stack.pop]
    end
  end
end
