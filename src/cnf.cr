struct Relation
  getter equal : Bool
  getter first : Int32, second : Int32
  property id : Int32

  def initialize(@first, @equal, @second)
    @id  = -1
  end
end

alias Clause = Array(Relation)
alias CNF = Array(Clause)

def annotate(cnf : CNF)
  id = -1
  relation_map = Hash(Int32, Relation).new
  h = Hash(Int32, Hash(Int32, Int32)).new { |h,k| h[k] = Hash(Int32,Int32).new }
  cnf.map! do |clause|
    clause.map do |relation|
      a, b = relation.first, relation.second
      i = h[a][b]? || h[b][a]? || (id += 1)
      relation.id = h[a][b] = i
      relation_map[i] = relation
      relation
    end
  end
  relation_map
end

def boolean_translate(cnf : CNF) : Array(Array({Bool, Int32}))
  cnf.map do |clause|
    clause.map do |relation|
      { relation.equal, relation.id }
    end
  end
end
