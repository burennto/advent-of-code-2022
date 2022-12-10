require 'minitest/autorun'

class Day04Test < Minitest::Test
  def setup
    @example = 'example.txt'
    @input = 'input.txt'
  end

  def test_part_1
    assert_equal 2, solve_part_1(@example)
    assert_equal 431, solve_part_1(@input)
  end

  def test_part_2
    assert_equal 4, solve_part_2(@example)
    assert_equal 823, solve_part_2(@input)
  end
end

class Elf
  attr_reader :start, :finish

  def initialize(start, finish)
    @start, @finish = start, finish
  end

  def contains?(elf)
    range.include?(elf.start) && range.include?(elf.finish)
  end

  def overlaps?(elf)
    range.include?(elf.start) || range.include?(elf.finish)
  end

  private

  def range
    @range ||= Range.new(start, finish)
  end
end

def parse_elf_pairs(file)
  File.readlines(file)
    .map(&:chomp)
    .map do |line|
      line.split(',').map { |string| Elf.new(*string.split('-').map(&:to_i)) }
    end
end

def solve_part_1(file)
  parse_elf_pairs(file).reduce(0) do |count, pairs|
    elf_1, elf_2 = pairs
    count += 1 if elf_1.contains?(elf_2) || elf_2.contains?(elf_1)
    count
  end
end

def solve_part_2(file)
  parse_elf_pairs(file).reduce(0) do |count, pairs|
    elf_1, elf_2 = pairs
    count += 1 if elf_1.overlaps?(elf_2) || elf_2.overlaps?(elf_1)
    count
  end
end
