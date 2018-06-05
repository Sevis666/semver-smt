require "spec"
require "./spec_helper.cr"

describe "Parser" do
  it "should fail if no descriptor is found" do
    file = create_testfile(["1<>2"])
    run(file).exit_code.should eq 2
    drop_testfile(file)
  end

  it "should fail if duplicate descriptor is found" do
    file = create_testfile(["p cnf 4 2", "p cnf 3 2"])
    run(file).exit_code.should eq 2
    drop_testfile(file)
  end

  pending "should fail if counts are not integers" do
    file = create_testfile(["1<>2"])
    run(file).exit_code.should eq 2
    drop_testfile(file)
  end
end
