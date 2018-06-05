require "spec"
require "./spec_helper.cr"

describe "Parser" do
  it "should fail(3) if no descriptor is found" do
    should_yield(["1<>2"], 3)
  end

  it "should fail(3) if duplicate descriptor is found" do
    should_yield(["p cnf 4 2", "p cnf 3 2"], 3)
  end

  it "should fail(3) if descriptor line is too short" do
    should_yield(["p cnf 4"], 3)
  end

  it "should fail(3) if counts are not integers" do
    should_yield(["p cnf a 2"], 3)
    should_yield(["p cnf 4 s"], 3)
  end

  it "should fail(3) if malformed relation is found" do
    p = "p cnf 1 2"
    [ "1 <> 2",
      "1!=2",
      "1<>a",
      "1=2 2=2 2=a",
      "a<>1 1=2"
    ].each do |line|
      should_yield([p, line], 3)
    end
  end
end
