require 'chunky_png'
include ChunkyPNG::Color

module Compatriot
  class ImageDiffer

    def self.diff(results, strategy = :color_difference)
      images = results.map{|r| ChunkyPNG::Image.from_file(r) }
      self.send(strategy, images.first, images.last, results.first)
    end

    def self.same_pixels_exactly(image1, image2, name)
      output = ChunkyPNG::Image.new(image1.width, image2.height, WHITE)
      diff = []

      # each_pixel(images.first, images.last) do |x, y|

      image1.height.times do |y|
        image1.row(y).each_with_index do |pixel, x|
          output[x,y] = pixel
          diff << [x,y] unless pixel == image2[x,y]
        end
      end

      pixels_total = image1.pixels.length
      pixels_changed = diff.length
      pixels_changed_percentage = (diff.length.to_f / image1.pixels.length) * 100

      x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

      output.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))
      filename = "#{name}-same_exactly.png"
      output.save(filename)
      File.join(
        File.basename(File.dirname(filename)),
        File.basename(filename)
      )
    end

    def self.color_difference(image1, image2, name)
      output = ChunkyPNG::Image.new(image1.width, image1.height, WHITE)
      diff = []

      image1.height.times do |y|
        image1.row(y).each_with_index do |pixel, x|
          unless pixel == image2[x,y]
            score = Math.sqrt(
              (r(image2[x,y]) - r(pixel)) ** 2 +
              (g(image2[x,y]) - g(pixel)) ** 2 +
              (b(image2[x,y]) - b(pixel)) ** 2
            ) / Math.sqrt(MAX ** 2 * 3)

            output[x,y] = grayscale(MAX - (score * MAX).round)
            diff << score
          end
        end
      end

      pixels_total = image1.pixels.length
      pixels_changed = diff.length
      pixels_changed_percentage = (diff.inject {|sum, value| sum + value} / image1.pixels.length) * 100

      filename = "#{name}-color_difference.png"
      output.save(filename)
      File.join(
        File.basename(File.dirname(filename)),
        File.basename(filename)
      )
    end
  end
end