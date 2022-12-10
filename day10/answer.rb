require 'minitest/autorun'

class Day10Test < Minitest::Test
  def test_example
    assert_equal 13140, solve('example.txt')
  end

  def test_answers
    assert_equal 12520, solve('input.txt')
  end
end

class Cpu
  attr_reader :x, :signal_strengths, :sprite_positions

  CYCLE_INDICES = [19, 59, 99, 139, 179, 219]

  SPRITE_WIDTH = 3

  PIXELS_PER_ROW = 40
  PIXEL_ON = '#'
  PIXEL_OFF = '.'

  def initialize
    @x = 1
    @signal_strengths = []
    @sprite_positions = (0..SPRITE_WIDTH-1)
  end

  def execute(line)
    case line
    when 'noop' then noop
    when /add(\w?) (-?\d+)/ then addx($2.to_i)
    end
  end

  def addx(value)
    cycle
    cycle

    self.x += value
    self.sprite_positions = Range.new(*sprite_positions.minmax.map { |n| n + value })
  end

  def noop
    cycle
  end

  def interesting_signal_strengths
    signal_strengths.values_at(*CYCLE_INDICES).compact
  end

  private

  attr_writer :x, :sprite_positions

  def cycle
    signal_strengths << x * current_cycle_number
    draw_pixel
  end

  def current_cycle_number
    signal_strengths.count + 1
  end

  def current_pixel_index
    index = (signal_strengths.count % PIXELS_PER_ROW) - 1
    index += index < 0 ? PIXELS_PER_ROW : 0
  end

  def draw_pixel
    print "\n#{self.sprite_positions.to_a} #{current_pixel_index} " if DEBUGGING

    print sprite_positions.include?(current_pixel_index) ? PIXEL_ON : PIXEL_OFF
    print "\n" if signal_strengths.count % PIXELS_PER_ROW == 0
  end
end

DEBUGGING = false

def solve(file)
  cpu = Cpu.new

  print("#{file} \n\n")

  File.foreach(file) do |line|
    cpu.execute(line.chomp)
  end

  print("\n")

  cpu.interesting_signal_strengths.sum
end
