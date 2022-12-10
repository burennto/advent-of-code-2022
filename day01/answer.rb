require 'minitest/autorun'

class Day01Test < Minitest::Test
  def test_example
    file = 'example.txt'

    assert_equal 24000, solve_part_1(file)
    assert_equal 45000, solve_part_2(file)
  end

  def test_input
    file = 'input.txt'

    assert_equal 70764, solve_part_1(file)
    assert_equal 203905, solve_part_2(file)
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
  elves = parse_elves(file)
  elves.max
end

def solve_part_2(file)
  elves = parse_elves(file)
  elves.max(3).sum
end
