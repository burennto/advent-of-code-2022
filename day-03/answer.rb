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

puts File.foreach('input.txt').with_object([]).each { |line, priorities|
  rucksack = Rucksack.new(line.chomp)
  priorities << Priority.for(rucksack.duplicate)
}.sum

puts File.foreach('input.txt').each_slice(3).with_object([]) { |lines, priorities|
  elves = lines.map(&:chomp)
  common_item = BadgeFinder.find_common_item(elves)
  priorities <<  Priority.for(common_item)
}.sum
