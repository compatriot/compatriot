require_relative '../spec_helper'

describe Compatriot::Runner do
  before do
    fake_date      = DateTime.parse("2012-01-01 00:00:00 UTC")
    @fake_date_dir = fake_date.strftime("%Y-%m-%d-%H-%M-%S")
    @fixed_clock   = OpenStruct.new(:now => fake_date)
  end

  describe "self#start" do
    it "creates a Runner instance and calls the other methods on it" do
      runner = stub

      Compatriot::Runner.expects(:new).returns(runner)
      runner.expects(:create_results_directory)
      runner.expects(:take_screenshots)
      runner.expects(:compute_diffs)
      runner.expects(:make_index_page)

      Compatriot::Runner.start(stub, stub)
    end
  end

  describe "#take_screenshots" do
    it "calls take_screenshots for each browser" do
      results = stub
      Compatriot::Results.stubs(:new).returns(results)

      app = stub
      paths = stub
      dir = "somedate"

      runner = Compatriot::Runner.new(app, paths, stub)
      runner.stubs(:results_directory).returns(dir)

      results.expects(:take_screenshots).with(
        :browser => "firefox",
        :app     => app,
        :paths   => paths,
        :results_directory => dir
      )
      results.expects(:take_screenshots).with(
        :browser => "chrome",
        :app     => app,
        :paths   => paths,
        :results_directory => dir
      )

      runner.take_screenshots
    end
  end


  describe "#results_directory" do
    it "names a results directory in tmp/results based on the clock" do
      results_dir_name = File.join("tmp", "results", @fake_date_dir)
      runner = Compatriot::Runner.new(TestApp, ["/"], @fixed_clock)

      runner.results_directory.must_equal(results_dir_name)
    end
  end

end