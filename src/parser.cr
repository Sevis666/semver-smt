require "./cnf"

def parse_file(filename) : CNF
  described = false
  variable_count, clause_count = 0, 0
  cnf = [] of Clause
  File.each_line(filename) do |l|
    next if l[0] == 'c'
    if l[0] == 'p'
      if described
        STDERR.puts "Duplicate p line in file"
        exit 3
      end
      described = true
      begin
        _, type, varc, clauc = l.split
        variable_count = varc.to_i
        clause_count = clauc.to_i
      rescue # IndexError or ArgumentError
        STDERR.puts "Invalid p line : #{l}"
        exit 3
      end
    else
      cnf << parse_clause l
    end
    unless described
      STDERR.puts "Missing p line in file"
      exit 3
    end
  end
  cnf
end

def parse_clause(line)
  clause = [] of Relation
  line.split.each do |relation|
    if relation.match(/^\d+=\d+$/)
      a, b = relation.split("=").map(&.to_i)
      clause << Relation.new(a, true, b)
    elsif relation.match(/^\d+<>\d+$/)
      a, b = relation.split("<>").map(&.to_i)
      clause << Relation.new(a, false, b)
    else
      STDERR.puts "Malformed relation \"#{relation}\""
      exit 3
    end
  end
  clause
end
