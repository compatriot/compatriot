require_relative '../../spec_helper'

describe Compatriot::ImageDiffer do
  describe "compute!" do
    it "diffs each set of images and stores the location by path" do
      d = Compatriot::ImageDiffer.new(
        :paths => ["/home"],
        :browsers => [
          stub(:absolute_screenshot_for => "1.png"),
          stub(:absolute_screenshot_for => "2.png")
        ]
      )
      d.expects(:diff).with(["1.png", "2.png"]).returns("diff.png")
      d.compute!
      d.diffs["/home"].must_equal("diff.png")
    end
  end
  describe "diff" do
    it "calls chunky_png on each image path" do
      file_one = stub
      file_two = stub

      ChunkyPNG::Image.expects(:from_file).with(file_one)
      ChunkyPNG::Image.expects(:from_file).with(file_two)

      c = Compatriot::ImageDiffer.new
      c.stubs(:color_difference)
      c.diff([file_one, file_two])
    end

    it "returns the filename of the diff" do
    end

    it "uses the strategy passed in" do
    end
  end

  describe "self#color_difference" do
    it "starts a new white image with the same dimensions" do
      diff = stub_everything
      ChunkyPNG::Image.expects(:new).with(
        1,
        2,
        ChunkyPNG::Image::WHITE
      ).returns(diff)

      image1 = stub_everything("1", :width => 1, :height => 2)
      image2 = stub_everything("2", :width => 3, :height => 4)

      Compatriot::ImageDiffer.new.color_difference(image1, image2, stub)
    end
  end
end