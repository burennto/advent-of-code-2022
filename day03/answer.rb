require 'minitest/autorun'

class Day03Test < Minitest::Test
  def setup
    @example = 'example.txt'
    @input = 'input.txt'
  end

  def test_part_1
    assert_equal 157, solve_part_1(@example)
    assert_equal 8085, solve_part_1(@input)
  end

  def test_part_2
    assert_equal 70, solve_part_2(@example)
    assert_equal 2515, solve_part_2(@input)
  end
end

require 'set'

class Rucksack
  attr_reader :c1, :c2

  def initialize(line)
    @c1, @c2 = line.split('').each_slice( (line.size/2.0).round ).to_a
  end

  def duplicate
    c1.detect { |item| c2.include?(item) }
  end
end

class Priority
  CHARS = ('a'..'z').to_a + ('A'..'Z').to_a

  def self.for(item)
    CHARS.index(item) + 1
  end
end

class BadgeFinder
  def self.find_common_item(elves)
    sets = elves.map { |elf| Set.new(elf.split('')) }
    (sets[0] & sets[1] & sets[2]).to_a.first
  end
end

def read_lines(file)
  File.readlines(file).map(&:chomp)
end

def solve_part_1(file)
  read_lines(file).reduce(0) do |sum, line|
    rucksack = Rucksack.new(line)
    sum += Priority.for(rucksack.duplicate)
  end
end

def solve_part_2(file)
  read_lines(file).each_slice(3).reduce(0) do |sum, elves|
    common_item = BadgeFinder.find_common_item(elves)
    sum += Priority.for(common_item)
  end
end
