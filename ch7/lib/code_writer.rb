# frozen_string_literal: true

class CodeWriter
  ARITHMETIC_ASM = {
    'add' => 'M=D+M',
    'sub' => 'M=M-D',
    'neg' => 'M=-M',
    'and' => 'M=D&M',
    'or'  => 'M=D|M',
    'not' => 'M=!M',
    'eq'  => 'D;JEQ',
    'gt'  => 'D;JGT',
    'lt'  => 'D;JLT',
  }.freeze

  SEGMENT_ASM = {
    'local' => 'LCL',
    'argument' => 'ARG',
    'this' => 'THIS',
    'that' => 'THAT',
  }.freeze

  PUSH_D_ONTO_STACK_ASM = <<~ASM.chomp
    @SP
    AM=M+1
    A=A-1
    M=D
  ASM

  POP_FROM_STACK_TO_D_ASM = <<~ASM.chomp
    @SP
    AM=M-1
    D=M
  ASM

  def initialize(file_name)
    @file_name = file_name
    @file = File.open(@file_name, "w", 0755)
    @increment_count = 0
    # asm = <<~ASM
    #   @256
    #   D=A
    #   @SP
    #   M=D
    # ASM
    # @file.print(asm)
  end

  def close
    asm = <<~ASM
      (END)
      @END
      0;JMP
    ASM
    @file.print(asm)
    @file.close
  end

  def write_arithmetic(command)
    case command
    when 'neg', 'not'
      asm = generate_unary_arithmetic(command)
    when 'add', 'sub', 'and', 'or'
      asm = generate_binary_arithmetic(command)
    when 'eq', 'gt', 'lt'
      asm = generate_comparison(command)
    end
    @file.print(asm)
  end

  def write_push_pop(command, segment, index)
    case command
    when :c_push
      case segment
      when 'constant'
        asm = generate_push_constant(index)
      when 'local', 'argument', 'this', 'that'
        asm = generate_push_multimemory(segment, index)
      when 'temp'
        asm = generate_push_temp(index)
      when 'pointer'
        asm = generate_push_pointer(index)
      end
    when :c_pop
      case segment
      when 'local', 'argument', 'this', 'that'
        asm = generate_pop_multimemory(segment, index)
      when 'temp'
        asm = generate_pop_temp(index)
      when 'pointer'
        asm = generate_pop_pointer(index)
      end
    end
    @file.print(asm)
  end

  private

  def generate_push_constant(index)
    <<~ASM
      @#{index}
      D=A
      #{PUSH_D_ONTO_STACK_ASM}
    ASM
  end

  def generate_push_multimemory(segment, index)
    <<~ASM
      @#{index}
      D=A
      @#{SEGMENT_ASM[segment]}
      A=D+M
      D=M
      #{PUSH_D_ONTO_STACK_ASM}
    ASM
  end

  def generate_push_temp(index)
    <<~ASM
      @R#{5 + index}
      D=M
      #{PUSH_D_ONTO_STACK_ASM}
    ASM
  end

  def generate_push_pointer(index)
    <<~ASM
      @#{index == 0 ? 'THIS' : 'THAT'}
      D=M
      #{PUSH_D_ONTO_STACK_ASM}
    ASM
  end

  def generate_pop_multimemory(segment, index)
    <<~ASM
      @#{index}
      D=A
      @#{SEGMENT_ASM[segment]}
      D=D+M
      @R13
      M=D
      #{POP_FROM_STACK_TO_D_ASM}
      @R13
      A=M
      M=D
    ASM
  end

  def generate_pop_temp(index)
    <<~ASM
      #{POP_FROM_STACK_TO_D_ASM}
      @R#{5 + index}
      M=D
    ASM
  end

  def generate_pop_pointer(index)
    <<~ASM
      #{POP_FROM_STACK_TO_D_ASM}
      @#{index == 0 ? 'THIS' : 'THAT'}
      M=D
    ASM
  end

  def generate_unary_arithmetic(command)
    <<~ASM
      @SP
      A=M-1
      #{ARITHMETIC_ASM[command]}
    ASM
  end

  def generate_binary_arithmetic(command)
    <<~ASM
      #{POP_FROM_STACK_TO_D_ASM}
      A=A-1
      #{ARITHMETIC_ASM[command]}
    ASM
  end

   def generate_comparison(command)
    @increment_count+=1
    <<~ASM
      #{POP_FROM_STACK_TO_D_ASM}
      A=A-1
      D=M-D
      @COMPARISON_TRUE#{@increment_count}
      #{ARITHMETIC_ASM[command]}
      D=0
      @COMPARISON_END#{@increment_count}
      0;JMP
      (COMPARISON_TRUE#{@increment_count})
      D=-1
      (COMPARISON_END#{@increment_count})
      @SP
      A=M-1
      M=D
    ASM
  end
end
