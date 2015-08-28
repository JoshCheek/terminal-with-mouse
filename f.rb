# Terminal Mouse info documented here
# http://www.x.org/docs/xterm/ctlseqs.pdf
require 'io/console'
$stdin.raw do

  def click_at(x, y)
    # current window size
    max_y, max_x = $stdout.winsize

    # each pixel is 2 chars
    x -= 1 if x.even?
    max_x /= 2

    burst = [
      "\e[#{y};1H",                                         # far left
      "\e[48;5;#{16 + rand(216)}m",                         # random colour
      "  " * max_x,                                         # horizontal beam
      *1.upto(max_y).map { |y_off| "\e[#{y_off};#{x}H  " }, # vertical beam
      "\e[0m",                                              # color off
    ].join
    print burst
  end

  def get_int
    buffer  = ""
    current = ""
    until current == "\r" || current == "\n"
      current = $stdin.getc
      $stdout.print current
      $stdout.flush
      buffer << current
    end
    buffer.to_i
  end

  # record and display 5 mouse clicks
  at_exit do
    print "\e[?25h"   # show cursor
    print "\e[?1000l" # don't record mouse
  end

  print "How many times would you like to record the mouse? "
  num_times = get_int

  print "\e[?25l"   # hide cursor
  print "\e[H\e[2J" # clear screen (go to top-left and clear to bottom right)
  print "\e[?1000h" # record mouse

  x = y = nil
  num_times.times do
    # only works with mouse clicks b/c Im just experimenting... so dont press keys

    # mouse down: "\e[M xy"
    4.times { $stdin.getc }

    # idk why, but they're offset like this, but they are also note that the indexes are 1-based, not 0-based
    x = $stdin.getc.force_encoding(Encoding::ASCII_8BIT).ord - 32
    y = $stdin.getc.force_encoding(Encoding::ASCII_8BIT).ord - 32

    click_at x, y
    6.times { $stdin.getc }           # mouse up: "\e[M#xy"
  end
end
