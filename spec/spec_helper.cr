def create_testfile(content : Array(String))
  rand = Random.rand(16 ** 5).to_s(16).rjust(5, '0')
  file = File.new("/tmp/smt-solver-test.#{rand}", "w")
  content.each do |line|
    file.puts line
  end
  file.close
  file.path
end

def drop_testfile(filename)
  File.delete(filename)
end

def run(filename)
  Process.run("bin/main", [filename])
end

def should_yield(content, value)
    file = create_testfile(content)
    run(file).exit_code.should eq value
    drop_testfile(file)
end
