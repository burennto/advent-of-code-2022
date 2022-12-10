require 'minitest/autorun'

class Day02Test < Minitest::Test
  def setup
    @example = 'example.txt'
    @input = 'input.txt'
  end

  def test_part_1
    assert_equal 15, solve_part_1(@example)
    assert_equal 12855, solve_part_1(@input)
  end

  def test_part_2
    assert_equal 12, solve_part_2(@example)
    assert_equal 13726, solve_part_2(@input)
  end
end

class HandShape
  attr_reader :shape

  ROCK = :rock
  PAPER = :paper
  SCISSORS = :scissors

  CHAR_TO_SHAPE = {
    'A' => ROCK,
    'B' => PAPER,
    'C' => SCISSORS,
    'X' => ROCK,
    'Y' => PAPER,
    'Z' => SCISSORS
  }

  CHAR_TO_OUTCOME = {
    'X' => :lose,
    'Y' => :draw,
    'Z' => :win
  }

  def self.from_shape_char(char)
    new(CHAR_TO_SHAPE[char])
  end

  def self.from_outcome_char(char, opponent)
    outcome = CHAR_TO_OUTCOME[char]

    case outcome
    when :lose then HandShape.new(opponent.losing_shape)
    when :draw then HandShape.new(opponent.shape)
    when :win then HandShape.new(opponent.winning_shape)
    end
  end

  def initialize(shape)
    @shape = shape
  end

  def rock?
    shape == ROCK
  end

  def paper?
    shape == PAPER
  end

  def scissors?
    shape == SCISSORS
  end

  def beat?(opponent)
    return true if rock? && opponent.scissors?
    return true if paper? && opponent.rock?
    return true if scissors? && opponent.paper?
  end

  def draw?(opponent)
    shape == opponent.shape
  end

  def lose_to?(opponent)
    !(beat?(opponent) || draw?(opponent))
  end

  def losing_shape
    return SCISSORS if rock?
    return ROCK if paper?
    return PAPER if scissors?
  end

  def winning_shape
    return PAPER if rock?
    return SCISSORS if paper?
    return ROCK if scissors?
  end
end

class Round
  attr_reader :opponent, :me

  def self.parse(line:, mode:)
    chars = line.split(' ')

    opponent = HandShape.from_shape_char(chars.first)

    me = case mode
    when :as_me then HandShape.from_shape_char(chars.last)
    when :as_outcome then HandShape.from_outcome_char(chars.last, opponent)
    end

    new(opponent: opponent, me: me)
  end

  def initialize(opponent:, me:)
    @opponent = opponent
    @me = me
  end

  def score
    shape_score + outcome_score
  end

  private

  def shape_score
    return 1 if me.rock?
    return 2 if me.paper?
    return 3 if me.scissors?
  end

  def outcome_score
    return 0 if opponent.beat?(me)
    return 3 if opponent.draw?(me)
    return 6 if opponent.lose_to?(me)
  end
end

def parse_lines(file)
  File.readlines(file).map(&:chomp)
end

def solve_part_1(file)
  parse_lines(file).reduce(0) do |final_score, line|
    final_score += Round.parse(line: line, mode: :as_me).score
  end
end

def solve_part_2(file)
  parse_lines(file).reduce(0) do |final_score, line|
    final_score += Round.parse(line: line, mode: :as_outcome).score
  end
end
