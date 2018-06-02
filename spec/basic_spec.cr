require "spec"

describe "bin/main" do
  it "Should exit with status 1 when called without arguments" do
    Process.run("bin/main").exit_code.should eq 1
  end

  it "Should exit wiht status 1 when argument is not a file name" do
    Process.run("bin/main", ["dashdhfadas"]).exit_code.should eq 1
  end
end
