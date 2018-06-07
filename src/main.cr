require "./assignement"
require "./parser"
require "./cnf"
require "./sat"

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
  until success
    a = sat_solve(boolean_cnf)
    success = check_assignement(a, relation_map)
    boolean_cnf << learn_clause(a) unless success
  end
else
  STDERR.print "#{PROGRAM_NAME}: cannot access '#{filename}'"
  STDERR.puts  " : No such file or directory"
  exit 2
end
