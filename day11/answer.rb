require 'minitest/autorun'

class Day11Test < Minitest::Test
  def test_part_1
    assert_equal 10605, solve_part_1(:example)
    assert_equal 55944, solve_part_1(:input)
  end

  def test_part_2
    assert_equal 2713310158, solve_part_2(@example)
    # assert_equal 2724, solve_part_2(@input)
  end
end

class KeepAway
  attr_reader :monkeys

  def initialize(monkeys)
    @monkeys = monkeys
  end

  def play(worry_reduction:)
    self.monkeys.each_with_index do |monkey, monkey_index|
      puts "Monkey #{monkey_index}:" if DEBUGGING

      until monkey.items.empty? do
        monkey.inspect_item(worry_reduction)

        result = monkey.test_item
        receiver_monkey_index = result ? monkey.throw_to[:true] : monkey.throw_to[:false]
        receiver_monkey = self.monkeys[receiver_monkey_index]

        puts "  Throwing item with worry level #{monkey.items[0]} to monkey #{receiver_monkey_index}" if DEBUGGING

        receiver_monkey.catch!(monkey.throw!)
      end
    end
  end

  def level_of_monkey_business
    self.monkeys.map(&:inspections).max(2).reduce(:*)
  end

  def to_s
    self.monkeys.map.with_index do |monkey, index|
      "Monkey #{index}: #{monkey.items}"
    end
  end
end

class Monkey
  attr_reader :items, :operation, :test, :throw_to, :inspections

  def initialize(items:, operation:, test:, throw_to:)
    @items = items
    @operation = operation
    @test = test
    @throw_to = throw_to
    @inspections = 0
  end

  def inspect_item(worry_reduction)
    puts "  Item worry level #{self.items[0]}" if DEBUGGING
    self.items[0] = self.operation.call(self.items[0])
    self.items[0] /= 3 if worry_reduction
    puts "  Item worry level now #{self.items[0]}" if DEBUGGING
    self.inspections += 1
  end

  def test_item
    self.test.call(self.items[0])
  end

  def throw!
    self.items.shift
  end

  def catch!(item)
    self.items << item
  end

  private
  attr_writer :items, :inspections
end

# load monkeys
require('./example')
require('./input')

DEBUGGING = false

def play_keep_away(mode:, rounds:, worry_reduction:)
  monkeys = mode == :example ? EXAMPLE_MONKEYS : INPUT_MONKEYS

  game = KeepAway.new(monkeys)
  rounds.times { game.play(worry_reduction: worry_reduction) }

  puts "=" * 50 if DEBUGGING
  puts game.to_s if DEBUGGING

  game.level_of_monkey_business
end

def solve_part_1(mode)
  play_keep_away(mode: mode, rounds: 20, worry_reduction: true)
end

def solve_part_2(mode)
  play_keep_away(mode: mode, rounds: 10_000, worry_reduction: false)
end
