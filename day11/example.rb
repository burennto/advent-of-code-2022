EXAMPLE_MONKEYS = [
  Monkey.new(
    items: [79, 88],
    operation: ->(old) { old * 19 },
    test: ->(item) { item % 23 == 0 },
    throw_to: { true: 2, false: 3 }
  ),
  Monkey.new(
    items: [54, 65, 75, 74],
    operation: ->(old) { old + 6 },
    test: ->(item) { item % 19 == 0 },
    throw_to: { true: 2, false: 0 }
  ),
  Monkey.new(
    items: [79, 60, 97],
    operation: ->(old) { old * old },
    test: ->(item) { item % 13 == 0 },
    throw_to: { true: 1, false: 3 }
  ),
  Monkey.new(
    items: [74],
    operation: ->(old) { old + 3 },
    test: ->(item) { item % 17 == 0 },
    throw_to: { true: 0, false: 1 }
  )
]
