class CrateStacks
  attr_reader :store

  def self.initialize_from_drawing(drawing)
    stacks = new(drawing.first.count)

    drawing.reverse_each do |row|
      row.each_with_index do |col, index|
        next if col == ''
        crate = Crate.new(col)
        stacks.get(index).push(crate)
      end
    end

    stacks
  end

  def initialize(cols)
    @store = Array.new(cols) { CrateStack.new }
  end

  def get(index)
    store[index]
  end

  def add(stack)
    store << stack
  end

  def tops
    store.map(&:peek).join
  end

  def move!(from:, to:, quantity:, mode:)
    case mode
    when :one_by_one then move_one_by_one(from: from, to: to, quantity: quantity)
    when :at_once then move_at_once(from: from, to: to, quantity: quantity)
    end
  end

  def to_s
    store.map(&:to_s)
  end

  private

  def move_one_by_one(from:, to:, quantity:)
    stack_from = get(from - 1)
    stack_to = get(to - 1)

    quantity.times { stack_to.push(stack_from.pop) }
  end

  def move_at_once(from:, to:, quantity:)
    tmp_stack = CrateStack.new
    stack_from = get(from - 1)
    stack_to = get(to - 1)

    quantity.times { tmp_stack.push(stack_from.pop) }
    stack_to.push(tmp_stack.pop) until tmp_stack.empty?
  end
end

class CrateStack
  attr_reader :store

  def self.parse
  end

  def initialize
    @store = []
  end

  def push(item)
    store << item
  end

  def pop
    store.pop
  end

  def peek
    store.last.char
  end

  def empty?
    store.empty?
  end

  def to_s
    store.map(&:to_s).join
  end
end

class Crate
  attr_reader :char

  def initialize(char)
    @char = char
  end

  def to_s
    char
  end
end

drawing = File.foreach('input.txt').with_object([]).each do |line, lines|
  break lines if line[0] == ' '
  lines << line.chomp.split('').each_slice(4).map { |arr| arr.join.delete('^A-Z') }
end

stacks_1 = CrateStacks.initialize_from_drawing(drawing)
stacks_2 = CrateStacks.initialize_from_drawing(drawing)

File.foreach('input.txt') do |line|
  next unless line[0..3] == 'move'

  quantity, pos_from, pos_to = line.chomp.split(' ').values_at(1, 3, 5).map(&:to_i)
  stacks_1.move!(from: pos_from, to: pos_to, quantity: quantity, mode: :one_by_one)
  stacks_2.move!(from: pos_from, to: pos_to, quantity: quantity, mode: :at_once)
end

puts stacks_1.tops
puts stacks_2.tops
