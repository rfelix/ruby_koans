require "test/unit"
require "test_unit_extensions"
require 'stringio'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'game'
require 'player'
require 'score'
require 'dice_set'

module StringIOHelper
  def provide_input(input)
    @input << input
    @input.rewind
  end

  def expect_output(output)
    assert_equal(output, @output.string)
  end
end