require "spec"
require "./spec_helper.cr"

describe "Parser" do
  it "should fail if no descriptor is found" do
    should_yield(["1<>2"], 2)
  end

  it "should fail if duplicate descriptor is found" do
    should_yield(["p cnf 4 2", "p cnf 3 2"], 2)
  end

  it "should fail if descriptor line is too short" do
    should_yield(["p cnf 4"], 2)
  end

  it "should fail if counts are not integers" do
    should_yield(["p cnf a 2"], 2)
    should_yield(["p cnf 4 s"], 2)
  end

  it "should fail if malformed relation is found" do
    p = "p cnf 1 2"
    [ "1 <> 2",
      "1!=2",
      "1<>a",
      "1=2 2=2 2=a",
      "a<>1 1=2"
    ].each do |line|
      should_yield([p, line], 2)
    end
  end
end
