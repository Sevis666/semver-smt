require "spec"
require "./spec_helper"

describe "SMT Solver" do
  it "should satisfy trivial cases" do
    run("tests/trivial.cnfuf").exit_code.should eq 0
  end

  it "should fail to satisfy trivial cases" do
    run("tests/untrivial.cnfuf").exit_code.should eq 1
  end
end
