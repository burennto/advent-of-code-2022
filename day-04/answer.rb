class Elf
  attr_reader :start, :finish

  def self.parse(line)
    line.chomp.split(',').map { |string| Elf.new(*string.split('-').map(&:to_i)) }
  end

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

puts File.foreach('input.txt').with_object([]).each { |line, pairs|
  elf_1, elf_2 = Elf.parse(line)
  pairs << true if elf_1.contains?(elf_2) || elf_2.contains?(elf_1)
}.count

puts File.foreach('input.txt').with_object([]).each { |line, pairs|
  elf_1, elf_2 = Elf.parse(line)
  pairs << true if elf_1.overlaps?(elf_2) || elf_2.overlaps?(elf_1)
}.count
