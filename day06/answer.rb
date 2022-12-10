require 'minitest/autorun'

class Day06Test < Minitest::Test
  def setup
    @input_string = File.read('input.txt').chomp
  end

  def test_part_1
    assert_equal 5, chars_checked('bvwbjplbgvbhsrlpgdmjqwftvncz', 4)
    assert_equal 6, chars_checked('nppdvjthqldpwncqszvftbrmjlhg', 4)
    assert_equal 10, chars_checked('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 4)
    assert_equal 11, chars_checked('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 4)

    assert_equal 1275, chars_checked(@input_string, 4)
  end

  def test_part_2
    assert_equal 3605, chars_checked(@input_string, 14)
  end
end

def chars_checked(string, marker_length)
  pointer = 0

  while pointer <= string.length - marker_length do
    substring_chars = string.slice(pointer, marker_length).split('')

    if substring_chars.uniq.length == marker_length
      return pointer + marker_length
    else
      pointer += 1
    end
  end

  nil
end
