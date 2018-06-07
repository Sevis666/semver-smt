class UnionFind
  def initialize(@n : Int32)
    @parent = Array(Int32).new(@n) { |i| i }
  end

  def find(i)
    return i if @parent[i] == i
    @parent[i] = find(@parent[i])
  end

  def merge(i, j)
    @parent[find(i)] = find(j)
  end
end
