# Terminal Mouse info documented here
# http://www.x.org/docs/xterm/ctlseqs.pdf
require 'io/console'
$stdin.raw do

  def print_at(x, y, char)
    print "\e[#{y};#{x}H#{char}"
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

  print "\e[?25l"   # hide cursor
  print "\e[H\e[2J" # clear screen (go to top-left and clear to bottom right)
  print "\e[?1000h" # record mouse

  print "How many times would you like to record the mouse? "
  num_times = get_int

  x = y = nil
  print
  num_times.times do
    # only works with mouse clicks b/c Im just experimenting, so dont press keys

    # mouse down: "\e[M xy"
    4.times { $stdin.getc }

    # idk why, but they're offset like this, but they are also note that the indexes are 1-based, not 0-based
    x = $stdin.getc.force_encoding(Encoding::ASCII_8BIT).ord - 32
    y = $stdin.getc.force_encoding(Encoding::ASCII_8BIT).ord - 32

    print_at x, y, "\e[4#{rand 8}m  " # print a randomly coloured x there
    6.times { $stdin.getc }           # mouse up: "\e[M#xy"
  end
end
