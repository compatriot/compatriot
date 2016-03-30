require_relative '../../spec_helper'

describe Compatriot::ImageDiffer do
  describe "compute!" do
    it "diffs each set of images and stores the location by path" do
      Compatriot::ImageDiffer.any_instance.stubs(:create_diffs_path)

      d = Compatriot::ImageDiffer.new(
        :paths => ["/home"],
        :browsers => [
          stub(:absolute_screenshot_for => "1.png"),
          stub(:absolute_screenshot_for => "2.png")
        ]
      )
      d.expects(:diff).with(["1.png", "2.png"]).returns("diff.png")
      d.compute!
      d.diff_for("/home").must_equal("diff.png")
    end

    it "creates a diffs dir" do
      FileUtils.expects(:mkdir_p).with("foo/bar/diffs")
      d = Compatriot::ImageDiffer.new(
        :results_directory => "foo/bar"
      )
      d.diffs_path.must_equal("foo/bar/diffs")
    end
  end

  describe "diff" do
    it "returns the filename of the diff" do
      file_one = stub
      file_two = stub
      strategy = stub(:diff => "diff_filename.png")
      ChunkyPNG::Image.stubs(:from_file)
      FileUtils.expects(:mkdir_p).with("something/diffs")

      c = Compatriot::ImageDiffer.new(
        :strategy => strategy,
        :results_directory => "something"
      )

      c.diff([file_one, file_two]).must_equal("diff_filename.png")
    end

    it "uses the strategy passed in" do
      file_one = stub
      file_two = stub
      strategy = stub

      ChunkyPNG::Image.stubs(:from_file).returns(file_one, file_two)
      FileUtils.expects(:mkdir_p).with("something/diffs")

      strategy.expects(:diff).with(
        file_one,
        file_two,
      ).returns("diff_filename.png")

      c = Compatriot::ImageDiffer.new(
        :strategy => strategy,
        :results_directory => "something"
      )

      c.diff([file_one, file_two]).must_equal("diff_filename.png")
    end
  end
end
