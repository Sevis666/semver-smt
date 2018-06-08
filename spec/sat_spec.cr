require "spec"
require "../src/sat"
require "../src/dpll_solver"

def init_cnf
  [] of Array({Bool, Int32})
end

def init_sat_solver(cnf = init_cnf)
  DPLLSolver.new(cnf)
end

describe SATSolver do
  describe "#reduce" do
    it "should collapse empty clauses" do
      s = init_sat_solver
      cnf = init_cnf
      cnf << [{false, 1}, {true, 2}]
      cnf << [] of {Bool, Int32}
      cnf << [{true, 3}]
      cnf << [] of {Bool, Int32}
      s.reduce(cnf).each do |c|
        c.empty?.should eq false
      end
    end

    it "should deduce pure literals" do
      cnf = init_cnf
      cnf << [{false, 1}]
      s = init_sat_solver(cnf)
      s.unassigned_variable.should be_nil
    end

    it "should raise when i<>i is found" do
      cnf = init_cnf
      cnf << [{false, -1}]
      expect_raises(UnsatisfiableException) do
        init_sat_solver(cnf)
      end
    end

    it "should not raise when i<>i can be ignored" do
      cnf = init_cnf
      cnf << [{false, -1}, {true, 1}]
      begin
        init_sat_solver(cnf)
      rescue UnsatisfiableException
        fail("raised UnsatisfiableException even though i<>i was ignorable")
      end
    end

    it "should ignore clauses containing i=i" do
      cnf = init_cnf
      cnf << [{false, 1}, {true, 2}, {false, 3}, {true, -1}, {false, 4}]
      s = init_sat_solver(cnf)
      s.unassigned_variable.should be_nil
    end
  end
end
