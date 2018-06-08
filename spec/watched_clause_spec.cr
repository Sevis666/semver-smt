require "spec"
require "../src/sat"

describe WatchedClause do
  it "should not be satisfied by empty assignement" do
    a = Assignement.new
    c = WatchedClause.new([{false, 0}, {false, 1}])
    c.satisfied?(a).should eq false
  end

  it "should not be satisfied by unrelated assignement" do
    a = Assignement.new
    c = WatchedClause.new([{false, 0}, {false, 1}])
    a.deduce(3, false)
    c.satisfied?(a).should eq false
  end

  it "should be satisfied in trivial cases" do
    a = Assignement.new
    c = WatchedClause.new([{true, 0}, {true, 1}, {false, 2}])
    a.deduce(0, true)
    c.satisfied?(a).should eq true # 0 is met

    a = Assignement.new
    c = WatchedClause.new([{true, 0}, {true, 1}, {false, 2}])
    a.deduce(1, true)
    c.satisfied?(a).should eq true # 1 is met

    a = Assignement.new
    c = WatchedClause.new([{true, 0}, {true, 1}, {false, 2}])
    a.deduce(2, false)
    c.satisfied?(a).should eq true # !2 is met
  end

  it "should properly list its literals" do
    c = WatchedClause.new([{true, 0}, {true, 1}, {false, 2}])
    c.literals.should eq [0,1,2]
  end

  it "should return unit literal when deducible" do
    a = Assignement.new
    c = WatchedClause.new([{true, 0}, {true, 1}, {false, 2}])
    a.deduce(0, false)
    a.deduce(1, false)
    c.shift_watchdog(a).should eq ({false, 2})
  end

  it "should have no eligible watchdogs when unsatisfiable" do
    a = Assignement.new
    c = WatchedClause.new([{true, 0}, {true, 1}, {false, 2}])
    a.deduce(0, false)
    a.deduce(1, false)
    a.deduce(2, true)
    a.defined?(2).should eq true
    a[2]?.should eq true
    c.eligible_watchdogs(a).empty?.should eq true
  end

  it "should have no eligible watchdogs when unsatisfiable" do
    a = Assignement.new
    c = WatchedClause.new([{false, 0}, {false, 1}, {true, 2}])
    a.deduce(0, true)
    a.deduce(1, true)
    a.deduce(2, false)
    a.defined?(2).should eq true
    a[2]?.should eq false
    c.eligible_watchdogs(a).empty?.should eq true
  end

  it "should raise error when unsatisfiable" do
    a = Assignement.new
    c = WatchedClause.new([{true, 0}, {true, 1}, {false, 2}])
    a.deduce(0, false)
    a.deduce(1, false)
    a.deduce(2, true)
    expect_raises(UnsatisfiableException) do
      c.shift_watchdog(a)
    end
  end
end
