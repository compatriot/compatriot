require_relative '../spec_helper'

describe Compatriot::Runner do
  before do
    fake_date      = DateTime.parse("2012-01-01 00:00:00 UTC")
    @fake_date_dir = fake_date.strftime("%Y-%m-%d-%H-%M-%S")
    @fixed_clock   = OpenStruct.new(:now => fake_date)
  end

  it "names a results directory in tmp/results based on the clock" do
    results_dir_name = File.join("tmp", "results", @fake_date_dir)
    x = Compatriot::Runner.new(TestApp, ["/"], @fixed_clock)

    x.results_directory.must_equal(results_dir_name)
  end

end