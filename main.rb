require './lib/rainsolve'
require 'highline'

rs = Rainsolver.new("a", "z", 0, 9, 4)
system("clear")
rs.prepare_data
rs.print_prologue
rs.run
rs.print_epilogue
