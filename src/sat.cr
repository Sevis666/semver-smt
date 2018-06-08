require "./assignement"

class UnsatisfiableException < Exception
end

class WatchedClause
  property clause : Array({Bool, Int32})
  property watchdog1 : Int32, watchdog2 : Int32

  def initialize(@clause)
    @watchdog1, @watchdog2 = literals
  end

  def literals
    @clause.map { |(b, i)| i }
  end

  def eligible_watchdogs(a)
    @clause.select { |(b,i)| ! a.defined?(i) || (b == a[i]?) }
  end

  def shift_watchdog(a : Assignement) : {Bool, Int32}?
    return nil if satisfied?(a)
    e_watchdogs = eligible_watchdogs(a)
    case e_watchdogs.size
    when 0
      raise UnsatisfiableException.new
    when 1
      return e_watchdogs.first
    when 2
      @watchdog1, @watchdog2 = e_watchdogs.map { |(b,i)| i }
      nil
    end
  end

  def satisfied?(a)
    clause.each do |(b, i)|
      v = a[i]?
      return true if ! v.nil? && b == v
    end
    return false
  end
end

abstract class SATSolver
  @cnf : Array(WatchedClause)

  def initialize(cnf : Array(Array({Bool, Int32})))
    @a = Assignement.new
    @cnf = reduce(cnf).map do |c|
      WatchedClause.new(c)
    end
  end

  abstract def solve : Assignement

  def boolean_propagation
    fixpoint = false
    until fixpoint
      fixpoint = true
      @cnf.each do |clause|
        res = clause.shift_watchdog(@a)
        unless res.nil?
          value, id = res
          fixpoint = false
          @a.deduce(id, value)
        end
      end
    end
  end

  def unassigned_variable : Int32?
    vars = @cnf.map { |wc| wc.clause.map { |(b, i)| i } }.flatten.uniq
    vars.each do |i|
      return i unless @a.defined?(i)
    end
  end

  def pick_branching_literal(l)
    @a.guess(l, true)
  end

  def backtrack
    @a.backtrack
  end

  def reduce(cnf)
    cnf.map do |clause|
      reduce_clause(clause)
    end.select { |c| ! c.empty? }
  end

  private def reduce_clause(clause)
    reduced = [] of {Bool, Int32}
    h = Hash(Int32, Bool).new
    has_always_false = false

    clause.each do |(value, id)|
      if id == -1
        if value
          return [] of {Bool, Int32}
        else
          has_always_false = true
          next
        end
      end

      if h.has_key?(id)
        raise UnsatisfiableException.new if h[id] != value
      else
        reduced << ({value, id})
        h[id] = value
      end
    end

    raise UnsatisfiableException.new if reduced.empty? && has_always_false
    if reduced.size == 1
      v, id = reduced.shift
      @a.deduce(id, v)
    end
    reduced
  end
end
