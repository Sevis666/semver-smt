require "./sat"

class DPLLSolver < SATSolver
  def solve
    loop do
      begin
        boolean_propagation
        if (l = unassigned_variable)
          pick_branching_literal(l)
        else
          return @a
        end
      rescue UnsatisfiableException
        backtrack
      end
    end
  end
end
