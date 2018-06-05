require "./parser"

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
  # TODO(Sevis): Run the actual code
  cnf = parse_file(filename)
else
  STDERR.print "#{PROGRAM_NAME}: cannot access '#{filename}'"
  STDERR.puts  " : No such file or directory"
  exit 2
end
