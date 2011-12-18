require_relative '../spec_helper'

describe Compatriot::ImageDiffer do
  describe "self#diff" do
    it "calls chunky_png on each image path" do
      file_one = stub
      file_two = stub

      ChunkyPNG::Image.expects(:from_file).with(file_one)
      ChunkyPNG::Image.expects(:from_file).with(file_two)
      Compatriot::ImageDiffer.stubs(:color_difference)

      Compatriot::ImageDiffer.diff([file_one, file_two])
    end

    it "returns the filename of the diff" do
    end

    it "uses the strategy passed in" do
    end
  end

  describe "self#color_difference" do
    it "starts a new white image with the same dimensions" do
      ChunkyPNG::Image.expects(:new).with(1, 2, ChunkyPNG::Image::WHITE)

      image1 = stub(:width => 1, :height => 2)

      Compatriot::ImageDiffer.color_difference([image1], stub)
    end
  end
end