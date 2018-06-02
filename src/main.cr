HELP = <<-EOS

Usage: #{PROGRAM_NAME} <file.cnfuf>

Return values:
  - 0 : Execution completed correctly
  - 1 : Invalid arguments
  - 2 : Invalid input file format
  - 3 : Formula not satisfiable


EOS

def help
  STDERR.puts HELP
  exit 1
end

if ARGV.size < 1
  help
end

filename = ARGV[0]
if File.exists?(filename)
  # TODO(Sevis): Run the actual code
else
  STDERR.print "#{PROGRAM_NAME}: cannot access '#{filename}'"
  STDERR.puts  " : No such file or directory"
  exit 1
end
