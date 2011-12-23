require 'chunky_png'
include ChunkyPNG::Color

module Compatriot
  class ColorDiffer

    def self.diff(filename1, filename2)
      image1 = ChunkyPNG::Image.from_file(filename1)
      image2 = ChunkyPNG::Image.from_file(filename2)

      output = ChunkyPNG::Image.new(image1.width, image1.height, WHITE)
      diff = []

      each_pixel(image1) do |x, y|
        pixel1 = image1[x,y]
        pixel2 = image2[x,y]
        unless pixel1 == pixel2
          output[x,y], score = color_difference_of_pixels(pixel1, pixel2)
          diff << score
        end
      end

      save_diff_image(output, filename1, filename2)
    end

    def self.save_diff_image(output, filename1, filename2)
      filename = diff_name(filename1, filename2)
      output.save(filename)
      File.join(
        File.basename(File.dirname(filename)),
        File.basename(filename)
      )
    end

    def self.diff_name(image1, image2)
      browser1 = File.basename(File.dirname(image1))
      browser2 = File.basename(File.dirname(image2))

      "color_#{browser1}_vs_#{browser2}_#{File.basename(image1)}"
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
    def color_difference_total_score
      pixels_total = image1.width * image1.height
      pixels_changed = diff.length
      pixels_changed_percentage = (diff.inject {|sum, value| sum + value} / pixels_total) * 100
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