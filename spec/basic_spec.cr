require "spec"
require "./spec_helper.cr"

describe "bin/main" do
  it "should fail(2) when called without arguments" do
    Process.run("bin/main").exit_code.should eq 2
  end

  it "should fail(2) when argument is not a file name" do
    run("dasjdalda").exit_code.should eq 2
  end
end
