# frozen_string_literal: true

class Parser
  def initialize(path)
    @lines = File.open(path, "r").readlines
    @index = -1
  end

  def has_more_lines?
    # 5行あるとして、@indexは0~4まで
    @lines.length > @index + 1
  end

  def advance
    # ループを回して空行、コメントじゃない行を探す
    while has_more_lines?
      @index += 1
      is_comment = current_line.start_with?('//')
      is_blank = current_line.empty?
      break if !is_comment && !is_blank
    end
  end

  def command_type
    tmp = current_line.split[0]
    case tmp
    when 'push'
      :c_push
    when 'pop'
      :c_pop
    when 'add', 'sub', 'neg', 'eq', 'gt', 'lt', 'and', 'or', 'not'
      :c_arithmetic
    end
  end

  def arg1
    # 1
    # push constant 1
    # => constant
    # 2
    # add
    # => add
    if (command_type == :c_arithmetic)
      return current_line
    end
    args = current_line.split
    args[1]
  end

  def arg2
    # push constant 1
    # => 1
    args = current_line.split
    args[2].to_i
  end

  private

  def current_line
    @lines[@index].split('//')[0].strip
  end
end
