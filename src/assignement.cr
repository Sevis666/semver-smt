require "./union_find"

class UnsatisfiableException < Exception
end

class Assignement
  struct Decision
    property id : Int32, decided : Bool, value : Bool
    def initialize(@id, @value, @decided); end
  end

  def initialize
    @data = Array(Decision).new
  end

  def guess(id, value)
    @data.unshift(Decision.new(id, value, decided: true))
  end

  def deduce(id, value)
    if self.defined?(id)
      raise UnsatisfiableException.new if value != self[id]?
    else
      @data.unshift(Decision.new(id, value, decided: false))
    end
  end

  def each(&block)
    @data.each do |decision|
      yield decision.id, decision.value
    end
  end

  def []?(i)
    @data.each do |decision|
      return decision.value if decision.id == i
    end
  end

  def defined?(i : Int32)
    @data.map { |d| d.id }.includes? i
  end

  def check(relation_map)
    u = UnionFind.new((@data.map { |d| d.id } + [0]).max + 1)
    # Merge values that are supposed to be equal
    each do |id, value|
      rel = relation_map[id]
      equal = value ^ rel.equal
      next unless equal
      u.merge(rel.first - 1, rel.second - 1)
    end
    # Check that values not supposed to be equal are indeed not
    each do |id, value|
      rel = relation_map[id]
      equal = value ^ rel.equal
      next if equal
      return false unless u.find(rel.first - 1) != u.find(rel.second - 1)
    end
    return true
  end

  def learn_clause
    clause = [] of {Bool, Int32}
    each do |id, value|
      clause << { ! value, id }
    end
    clause
  end

  def backtrack
    while ! @data.empty? && ! @data.first.decided
      @data.shift
    end
    raise UnsatisfiableException.new if @data.empty?
    decision = @data.shift
    deduce(decision.id, ! decision.value)
  end
end

