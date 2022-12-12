INPUT_MONKEYS = [
  Monkey.new(
    items: [66, 71, 94],
    operation: ->(old) { old * 5 },
    test: ->(item) { item % 3 == 0 },
    throw_to: { true: 7, false: 4 }
  ),
  Monkey.new(
    items: [70],
    operation: ->(old) { old + 6 },
    test: ->(item) { item % 17 == 0 },
    throw_to: { true: 3, false: 0 }
  ),
  Monkey.new(
    items: [62, 68, 56, 65, 94, 78],
    operation: ->(old) { old + 5 },
    test: ->(item) { item % 2 == 0 },
    throw_to: { true: 3, false: 1 }
  ),
  Monkey.new(
    items: [89, 94, 94, 67],
    operation: ->(old) { old + 2 },
    test: ->(item) { item % 19 == 0 },
    throw_to: { true: 7, false: 0 }
  ),
  Monkey.new(
    items: [71, 61, 73, 65, 98, 98, 63],
    operation: ->(old) { old * 7 },
    test: ->(item) { item % 11 == 0 },
    throw_to: { true: 5, false: 6 }
  ),
  Monkey.new(
    items: [55, 62, 68, 61, 60],
    operation: ->(old) { old + 7 },
    test: ->(item) { item % 5 == 0 },
    throw_to: { true: 2, false: 1 }
  ),
  Monkey.new(
    items: [93, 91, 69, 64, 72, 89, 50, 71],
    operation: ->(old) { old + 1 },
    test: ->(item) { item % 13 == 0 },
    throw_to: { true: 5, false: 2 }
  ),
  Monkey.new(
    items: [76, 50],
    operation: ->(old) { old * old },
    test: ->(item) { item % 7 == 0 },
    throw_to: { true: 4, false: 6 }
  )
]
