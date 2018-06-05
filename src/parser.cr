struct Literal
  property equal : Bool
  property first, second : Int32

  def initialize(@first, @equal, @second); end
end

alias Clause = Array(Literal)
alias CNF = Array(Clause)

def parse_file(filename) : CNF
  described = false
  variable_count, clause_count = 0, 0
  cnf = [] of Clause
  File.each_line(filename) do |l|
    next if l[0] == 'c'
    if l[0] == 'p'
      if described
        STDERR.puts "Duplicate p line in file"
        exit 2
      end
      described = true
      _, type, varc, clauc = l.split
      variable_count = varc.to_i
      clause_count = clauc.to_i
    end
    unless described
      STDERR.puts "Missing p line in file"
      exit 2
    end
  end
  cnf
end
