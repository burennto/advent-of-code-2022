require 'minitest/autorun'

class Day01Test < Minitest::Test
  def setup
    @example = 'example.txt'
    @input = 'input.txt'
  end

  def test_part_1
    assert_equal 24000, solve_part_1(@example)
    assert_equal 70764, solve_part_1(@input)
  end

  def test_part_2
    assert_equal 45000, solve_part_2(@example)
    assert_equal 203905, solve_part_2(@input)
  end
end

def parse_elves(file)
  File.read(file)
    .split("\n\n")
    .map do |items|
      items.split("\n")
        .map(&:to_i)
        .sum
    end
end

def solve_part_1(file)
  parse_elves(file).max
end

def solve_part_2(file)
  parse_elves(file).max(3).sum
end
