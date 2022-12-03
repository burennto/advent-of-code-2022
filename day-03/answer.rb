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

answer_1 = 0
answer_2 = 0

File.foreach('input.txt') do |line|
  rucksack = Rucksack.new(line.chomp)
  priority = Priority.for(rucksack.duplicate)
  answer_1 += priority
end

File.foreach('input.txt').each_slice(3) do |lines|
  elves = lines.map(&:chomp)
  common_item = BadgeFinder.find_common_item(elves)
  priority = Priority.for(common_item)
  answer_2 += priority
end

puts answer_1
puts answer_2
