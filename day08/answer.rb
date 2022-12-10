require 'minitest/autorun'

class Day08Test < Minitest::Test
  def setup
    @example = 'example.txt'
    @input = 'input.txt'
  end

  def test_part_1
    assert_equal 21, solve_part_1(@example)
    assert_equal 1713, solve_part_1(@input)
  end

  def test_part_2
    assert_equal 8, solve_part_2(@example)
    assert_equal 268464, solve_part_2(@input)
  end
end

class Tree
  attr_reader :x, :y, :height, :is_edge

  def initialize(x:, y:, height:, is_edge:)
    @x, @y = x, y
    @height = height
    @is_edge = is_edge
  end

  def key
    [x, y]
  end
end

class Grid
  attr_reader :lookup, :width, :height

  def initialize(width:, height:)
    @lookup = {}
    @width, @height = width, height
  end

  def add_tree(tree)
    lookup[tree.key] = tree
  end

  def trees_visible
    lookup.values.select { |tree| visible?(tree) }
  end

  def scenic_scores
    lookup.values.map { |tree| scenic_score(tree) }
  end

  private

  def visible?(tree)
    return true if tree.is_edge

    surrounding_trees = find_surrounding_trees(tree)

    surrounding_trees.any? do |trees_in_direction|
      trees_in_direction.map(&:height).all? { |height| height < tree.height }
    end
  end

  def find_surrounding_trees(tree)
    [
      trees_north_of(tree),
      trees_south_of(tree),
      trees_west_of(tree),
      trees_east_of(tree)
    ]
  end

  def trees_north_of(tree)
    y_range = (0 ... tree.y).to_a
    keys = y_range.map { |y| [tree.x, y] }
    lookup.values_at(*keys)
  end

  def trees_south_of(tree)
    y_range = (tree.y+1 ... self.height).to_a
    keys = y_range.map { |y| [tree.x, y] }
    lookup.values_at(*keys)
  end

  def trees_west_of(tree)
    x_range = (0 ... tree.x).to_a
    keys = x_range.map { |x| [x, tree.y] }
    lookup.values_at(*keys)
  end

  def trees_east_of(tree)
    x_range = (tree.x+1 ... self.width).to_a
    keys = x_range.map { |x| [x, tree.y] }
    lookup.values_at(*keys)
  end

  def scenic_score(tree)
    north = distance_visible(trees_north_of(tree).reverse, tree)
    south = distance_visible(trees_south_of(tree), tree)
    west = distance_visible(trees_west_of(tree).reverse, tree)
    east = distance_visible(trees_east_of(tree), tree)

    north * south * west * east
  end

  def distance_visible(trees_in_direction, tree)
    slices = trees_in_direction.map(&:height).slice_when { |height| height >= tree.height }.to_a
    (slices.first || []).count
  end
end

def build_grid(file)
  input = File.readlines(file).map { |line| line.chomp.split('').map(&:to_i) }

  grid_width = input.first.count
  grid_height = input.count

  grid = Grid.new(width: grid_width, height: grid_height)

  input.each_with_index do |row, y|
    row.each_with_index do |tree_height, x|
      is_edge = x == 0 || x == grid_width - 1 || y == 0 || y == grid_height - 1
      tree = Tree.new(x: x, y: y, height: tree_height, is_edge: is_edge)
      grid.add_tree(tree)
    end
  end

  grid
end

def solve_part_1(file)
  grid = build_grid(file)
  grid.trees_visible.count
end

def solve_part_2(file)
  grid = build_grid(file)
  grid.scenic_scores.max
end
