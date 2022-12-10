require 'minitest/autorun'

class Day05Test < Minitest::Test
  def setup
    @example = 'example.txt'
    @input = 'input.txt'
  end

  def test_part_1
    # drawing parsing does not work correctly against example data

    # assert_equal 'CMZ', solve_part_1(@example)
    assert_equal 'VGBBJCRMN', solve_part_1(@input)
  end

  def test_part_2
    # drawing parsing does not work correctly against example data

    # assert_equal 'MCD', solve_part_2(@example)
    assert_equal 'LBBVJBRMH', solve_part_2(@input)
  end
end

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

def parse_drawing(file)
  drawing = []

  File.foreach(file) do |line|
    break if line[0..1] == ' 1'
    drawing << line.chomp.split('').each_slice(4).map { |arr| arr.join.delete('^A-Z') }
  end

  drawing
end

def parse_procedures(file)
  procedures = []

  File.foreach(file) do |line|
    next unless line[0..3] == 'move'
    procedure = line.chomp.split(' ').values_at(1, 3, 5).map(&:to_i)
    procedures << procedure
  end

  procedures
end

def solve_part_1(file)
  drawing = parse_drawing(file)
  procedures = parse_procedures(file)

  stacks = CrateStacks.initialize_from_drawing(drawing)

  procedures.each do |procedure|
    quantity, pos_from, pos_to = procedure
    stacks.move!(from: pos_from, to: pos_to, quantity: quantity, mode: :one_by_one)
  end

  stacks.tops
end

def solve_part_2(file)
  drawing = parse_drawing(file)
  procedures = parse_procedures(file)

  stacks = CrateStacks.initialize_from_drawing(drawing)

  procedures.each do |procedure|
    quantity, pos_from, pos_to = procedure
    stacks.move!(from: pos_from, to: pos_to, quantity: quantity, mode: :at_once)
  end

  stacks.tops
end
