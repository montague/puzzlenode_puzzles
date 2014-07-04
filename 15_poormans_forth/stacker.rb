require 'byebug'
module Stacker

  class Interpreter

    attr_reader :stack

    def initialize
      @stack = []
      @execute_until_stack = []
      @conditional_stack = []
    end

    def execute(command)
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
      else
        if execute?
          if is_number?(command)
            @stack.push(command.to_i)
          else
            @stack.push(command)
          end
        end
      end
    end

    private
    def __execute(method)
      send("execute_#{method}") if execute?
    end

    def execute?
      if @conditional_stack.last == :if &&
        @execute_until_stack.last == :else
        true
      elsif @conditional_stack.last == :else &&
        @execute_until_stack.last == :then 
        true
      elsif @conditional_stack.empty?
        true
      else
        false
      end
    end

    def execute_then
      @execute_until_stack.pop
      @conditional_stack.pop
    end

    def execute_else
      @conditional_stack.pop
      @conditional_stack.push :else
    end

    def execute_if
      arg = @stack.pop
      @conditional_stack.push :if
      if arg == ":true"
        @execute_until_stack.push :else
      elsif arg == ":false"
        @execute_until_stack.push :then
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
        result ? :true : :false
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

    def is_number?(str)
      str =~ /\A[+-]?\d+\z/
    end
  end
end
