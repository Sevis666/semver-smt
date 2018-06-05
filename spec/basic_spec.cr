require "spec"
require "./spec_helper.cr"

describe "bin/main" do
  it "should exit with status 1 when called without arguments" do
    Process.run("bin/main").exit_code.should eq 1
  end

  it "should exit wiht status 1 when argument is not a file name" do
    run("dasjdalda").exit_code.should eq 1
  end
end
