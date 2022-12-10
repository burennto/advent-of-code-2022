input = File.read('input.txt')

elves = input.split("\n\n").map { |items| items.split("\n").map(&:to_i).sum }

puts elves.max
puts elves.max(3).sum
