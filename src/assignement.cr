require "./union_find"

alias Assignement = Hash(Int32, Bool)

def defined?(i : Int32, a : Assignement)
  a.has_key? i
end

def check_assignement(a : Assignement, relation_map)
  u = UnionFind.new(a.keys.max)
  # Merge values that are supposed to be equal
  a.each do |id, value|
    rel = relation_map[id]
    equal = value ^ rel.equal
    next unless equal
    u.merge(rel.first, rel.second)
  end
  # Check that values not supposed to be equal are indeed not
  a.each do |id, value|
    rel = relation_map[id]
    equal = value ^ rel.equal
    next if equal
    return false unless u.find(rel.first) != u.find(rel.second)
  end
  return true
end

def learn_clause(a : Assignement)
  clause = [] of {Bool, Int32}
  a.each do |id, value|
    clause << { ! value, id }
  end
  clause
end
