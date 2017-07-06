require 'oily_png'
include ChunkyPNG::Color

module Compatriot
  class ColorDiffer

    def self.diff_to_file(filename1, filename2, output_filename)
      image1 = ChunkyPNG::Image.from_file(filename1)
      image2 = ChunkyPNG::Image.from_file(filename2)

      output = ChunkyPNG::Image.new(image1.width, image1.height, WHITE)
      diff = []

      each_pixel(image1) do |x, y|
        pixel1 = image1[x,y]
        # If the dimensions of the comparison image are not exactly
        # the same as image1, ChunkyPNG throws an error and we get
        # no diff. Let's produce a diff instead
        begin
          pixel2 = image2[x,y]
        rescue ChunkyPNG::OutOfBounds
          pixel2 = 0 # Make it black
        end
        unless pixel1 == pixel2
          output[x,y], score = color_difference_of_pixels(pixel1, pixel2)
          diff << score
        end
      end

      output.save(output_filename)
    end

    def self.diff(filename1, filename2)
      image1 = ChunkyPNG::Image.from_file(filename1)
      image2 = ChunkyPNG::Image.from_file(filename2)

      output = ChunkyPNG::Image.new(image1.width, image1.height, WHITE)
      diff = []

      each_pixel(image1) do |x, y|
        pixel1 = image1[x,y]
        # If the dimensions of the comparison image are not exactly
        # the same as image1, ChunkyPNG throws an error and we get
        # no diff. Let's produce a diff instead
        begin
          pixel2 = image2[x,y]
        rescue ChunkyPNG::OutOfBounds
          pixel2 = 0 # Make it black
        end
        unless pixel1 == pixel2
          output[x,y], score = color_difference_of_pixels(pixel1, pixel2)
          diff << score
        end
      end

      save_diff_image(output, File.basename(filename1), File.basename(filename2))

      diff
    end

    def self.save_diff_image(output, filename1, filename2)
      path = Compatriot.filepath_for_screenshot('diffs', filename1)
      create_directory_if_necessary(path)
      output.save(path)
    end

    def self.create_directory_if_necessary(file)
      dir = File.dirname(file)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
    end

    def self.color_difference_of_pixels(pixel1, pixel2)
      score = Math.sqrt(
        (r(pixel2) - r(pixel1)) ** 2 +
        (g(pixel2) - g(pixel1)) ** 2 +
        (b(pixel2) - b(pixel1)) ** 2
      ) / Math.sqrt(MAX ** 2 * 3)

      [grayscale(MAX - (score * MAX).round), score]
    end

    # Not called anywhere
    def self.color_difference_percentage(image, diff)
      return 0 if diff.length == 0
      (diff.reduce(:+) / image.pixels.length) * 100
    end

    def self.each_pixel(image)
      image.width.times do |x|
        image.height.times do |y|
          yield(x, y)
        end
      end
    end
  end
end
