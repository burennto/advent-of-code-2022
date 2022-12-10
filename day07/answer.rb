require 'minitest/autorun'

class Day7Test < Minitest::Test
  def test_example
    assert_equal 95437, solve_part_1('example.txt')
  end

  def test_answer
    assert_equal 2061777, solve_part_1('input.txt')
    assert_equal 4473403, solve_part_2('input.txt')
  end
end

class FileSystem
  attr_reader :root, :working_dir, :dirs

  def initialize
    @root = DirNode.new(parent: nil, name: '/')
    @working_dir = root
    @dirs = []
  end

  def change_dir(dir_name)
    if dir_name == '/'
      self.working_dir = self.root
    elsif dir_name == '..'
      self.working_dir = self.working_dir.parent
    else
      existing_dir_node = self.working_dir.get_child(dir_name)
      self.working_dir = existing_dir_node || DirNode.new(parent: self.working_dir, name: dir_name)
    end

    p "WORKING_DIR is now #{self.working_dir.name}" if DEBUGGING
  end

  def add_dir(name)
    dir_node = DirNode.new(parent: self.working_dir, name: name)
    self.working_dir.add_child(dir_node)
    self.dirs << dir_node

    p "ADDED DIR #{dir_node.name} to #{self.working_dir.name}" if DEBUGGING
  end

  def add_file(name, size)
    file_node = FileNode.new(parent: working_dir, name: name, size: size)
    self.working_dir.add_child(file_node)

    p "ADDED FILE #{file_node.name} to #{self.working_dir.name}" if DEBUGGING
  end

  private

  attr_writer :root, :working_dir
end

class Node
  attr_reader :parent, :name, :size, :children

  def initialize(parent:, name:, size:)
    @parent = parent
    @name = name
    @size = size
    @children = {}
  end

  def add_child(node)
    self.children[node.name] = node
  end

  def get_child(name)
    self.children[name]
  end
end

class DirNode < Node
  def initialize(parent:, name:)
    super(parent: parent, name: name, size: 0)
  end

  def total_size
    children.values.map(&:total_size).sum
  end

  def to_s
    "#{self.class} name: #{name}, children: #{children.count}"
  end
end

class FileNode < Node
  def initialize(parent:, name:, size:)
    super(parent: parent, name: name, size: size)
  end

  def total_size
    size
  end
end

DEBUGGING = FALSE

def build_file_system(file)
  fs = FileSystem.new

  input = File.readlines(file).map(&:chomp)

  input.each do |line|
    case line
    when /\$ cd (\S+)/
      fs.change_dir($1)
    when /\$ ls/
      # do nothing
    when /dir (\w+)/
      fs.add_dir($1)
    when /(\d+) (\S+)/
      fs.add_file($2, $1.to_i)
    end
  end

  fs
end

def solve_part_1(file)
  fs = build_file_system(file)

  fs.dirs.reduce(0) do |sum, dir_node|
    sum += dir_node.total_size if dir_node.total_size < 100_000
    sum
  end
end

def solve_part_2(file)
  fs = build_file_system(file)

  space_total = 70_000_000
  space_required = 30_000_000

  space_used = fs.root.total_size
  space_available = space_total - space_used

  fs.dirs.select do |dir_node|
    space_available + dir_node.total_size >= space_required
  end.map(&:total_size).sort.first
end
