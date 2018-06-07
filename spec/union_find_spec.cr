require "spec"
require "../src/union_find"

describe UnionFind do
  it "should create singletons by default" do
    u = UnionFind.new(10)
    10.times do |i|
      u.find(i).should eq i
    end
  end

  describe "#merge" do
    it "should merge two elements" do
      u = UnionFind.new(10)
      u.merge(0,1)
      u.find(0).should eq u.find(1)
    end

    it "should merge transitively" do
      u = UnionFind.new(10)
      u.merge(0,1)
      u.merge(1,2)
      u.find(0).should eq u.find(2)
    end

    it "should merge regardless of order" do
      u = UnionFind.new(10)
      u.merge(0,1)
      u.merge(2,3)
      u.merge(1,2)
      u.find(0).should eq u.find(3)
      u.find(0).should eq u.find(2)
      u.find(0).should eq u.find(1)
      u.find(1).should eq u.find(3)
      u.find(2).should eq u.find(3)
    end

    it "should not alter other elements" do
      u = UnionFind.new(10)
      u.merge(0,1)
      u.merge(0,2)
      u.merge(0,3)
      u.merge(6,7)
      u.find(9).should eq 9
      u.find(0).should eq u.find(3)
      u.find(5).should eq 5
    end
  end
end
