require 'minitest/autorun'

class Day9Test < Minitest::Test
  def test_example
    assert_equal 13, solve_part_1('example1.txt')
    assert_equal 1, solve_part_2('example1.txt')
    assert_equal 36, solve_part_2('example2.txt')
  end

  def test_answers
    assert_equal 6503, solve_part_1('input.txt')
    assert_equal 2724, solve_part_2('input.txt')
  end
end

class Rope
  attr_reader :knots

  def initialize(num_knots)
    @knots = num_knots.times.map do |n|
      name = n == 0 ? 'HEAD' : "KNOT #{n}"
      Knot.new(name)
    end

    @head = self.knots.first
    @tail = self.knots.last
  end

  def execute(line)
    direction, steps = line.split(' ')
    steps.to_i.times do |n|
      puts '#' * 50 if DEBUGGING
      puts "#{direction} #{n+1}" if DEBUGGING
      move!(direction.downcase.to_sym)
    end
  end

  def move!(direction)
    head.move!(direction)

    knots.each_cons(2) do |k1, k2|
      k2.follow!(k1) unless touching?(k1, k2)
    end
  end

  def tail_visited
    tail.visited
  end

  private

  attr_accessor :head, :tail

  def touching?(k1, k2)
    distance(k1, k2) < 2
  end

  def distance(k1, k2)
    Math.sqrt(((k2.x - k1.x) ** 2) +((k2.y - k1.y) ** 2))
  end
end

class Knot
  attr_reader :name, :x, :y, :visited, :most_recent_direction

  def initialize(name)
    @name = name
    @x, @y = [0, 0]
    @visited = { [0, 0] => 1 }
    @most_recent_direction = nil
  end

  def move!(direction)
    key_before = key

    case direction
    when :u then self.y += 1
    when :d then self.y -= 1
    when :l then self.x -= 1
    when :r then self.x += 1
    end

    self.most_recent_direction = direction

    puts "#{name}: #{key_before} => #{key} (#{direction.upcase})" if DEBUGGING
  end

  def follow!(other_knot)
    move!(:u) if other_knot.above?(self)
    move!(:d) if other_knot.below?(self)
    move!(:l) if other_knot.left_of?(self)
    move!(:r) if other_knot.right_of?(self)
    mark_visited!
    puts '*' if DEBUGGING
  end

  def below?(other_knot)
    y < other_knot.y
  end

  def above?(other_knot)
    y > other_knot.y
  end

  def left_of?(other_knot)
    x < other_knot.x
  end

  def right_of?(other_knot)
    x > other_knot.x
  end

  def mark_visited!
    visited[key] = (visited[key] || 0) + 1
  end

  def key
    [self.x, self.y]
  end

  def to_s
    key
  end

  private

  attr_writer :x, :y, :visited, :most_recent_direction
end

DEBUGGING = true

def solve_part_1(file)
  rope = Rope.new(2)

  File.foreach(file) do |line|
    rope.execute(line)
  end

  rope.tail_visited.count
end

def solve_part_2(file)
  rope = Rope.new(10)

  File.foreach(file) do |line|
    rope.execute(line)
  end

  rope.tail_visited.count
end
