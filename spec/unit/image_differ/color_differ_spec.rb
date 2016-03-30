require_relative '../../spec_helper'

describe Compatriot::ColorDiffer do
  it "calls chunky_png on each image path" do
    image1 = stub_everything("1", :width => 1, :height => 2)
    image2 = stub_everything("2", :width => 3, :height => 4)

    ChunkyPNG::Image.expects(:from_file).with("file_one").returns(image1)
    ChunkyPNG::Image.expects(:from_file).with("file_two").returns(image2)
    Compatriot::ColorDiffer.stubs(:save_diff_image)

    Compatriot::ColorDiffer.diff("file_one", "file_two")
  end

  it "starts a new white image with the same dimensions" do
    diff_image = stub_everything
    ChunkyPNG::Image.expects(:new).with(
      1,
      2,
      ChunkyPNG::Image::WHITE
    ).returns(diff_image)

    image1 = stub_everything("1", :width => 1, :height => 2)
    image2 = stub_everything("2", :width => 3, :height => 4)

    ChunkyPNG::Image.stubs(:from_file).returns(image1, image2)
    Compatriot::ColorDiffer.stubs(:save_diff_image)

    Compatriot::ColorDiffer.diff("/some/file/path.png", "/some/file/path.png")
  end
end
