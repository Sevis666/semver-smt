require "./assignement"
require "./parser"
require "./cnf"
require "./sat"
require "./dpll_solver"

HELP = <<-EOS

Usage: #{PROGRAM_NAME} <file.cnfuf>

Return values:
  - 0 : Execution completed correctly
  - 1 : Formula not satisfiable
  - 2 : Invalid arguments
  - 3 : Invalid input file format
  - 4 : Internal error


EOS

def help
  STDERR.puts HELP
  exit 2
end

if ARGV.size < 1
  help
end

filename = ARGV[0]
if File.exists?(filename)
  cnf = parse_file(filename)
  relation_map = annotate cnf
  boolean_cnf = boolean_translate(cnf)
  success = false
  begin
    until success
      a = sat_solve(boolean_cnf)
      success = a.check(relation_map)
      boolean_cnf << a.learn_clause unless success
    end
    STDERR.puts "SATISFIABLE"
    exit 0
  rescue UnsatisfiableException
    STDERR.puts "UNSATISFIABLE"
    exit 1
  end
else
  STDERR.print "#{PROGRAM_NAME}: cannot access '#{filename}'"
  STDERR.puts  " : No such file or directory"
  exit 2
end

def sat_solve(cnf)
  DPLLSolver.new(cnf).solve
end
