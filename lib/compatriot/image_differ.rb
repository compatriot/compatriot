require 'chunky_png'
include ChunkyPNG::Color

module Compatriot
  class ImageDiffer

    def self.diff(results, strategy = :color_difference)
      images = results.map{|r| ChunkyPNG::Image.from_file(r) }
      self.send(strategy, images, results.first)
    end

    def self.same_pixels_exactly(images, name)
      output = ChunkyPNG::Image.new(images.first.width, images.first.height, WHITE)
      diff = []

      # each_pixel(images.first, images.last) do |x, y|

      images.first.height.times do |y|
        images.first.row(y).each_with_index do |pixel, x|
          output[x,y] = pixel
          diff << [x,y] unless pixel == images.last[x,y]
        end
      end

      pixels_total = images.first.pixels.length
      pixels_changed = diff.length
      pixels_changed_percentage = (diff.length.to_f / images.first.pixels.length) * 100

      x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

      output.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))
      filename = "#{name}-same_exactly.png"
      output.save(filename)
      File.join(
        File.basename(File.dirname(filename)),
        File.basename(filename)
      )
    end

    def self.color_difference(images, name)
      output = ChunkyPNG::Image.new(images.first.width, images.first.height, WHITE)
      diff = []

      images.first.height.times do |y|
        images.first.row(y).each_with_index do |pixel, x|
          unless pixel == images.last[x,y]
            score = Math.sqrt(
              (r(images.last[x,y]) - r(pixel)) ** 2 +
              (g(images.last[x,y]) - g(pixel)) ** 2 +
              (b(images.last[x,y]) - b(pixel)) ** 2
            ) / Math.sqrt(MAX ** 2 * 3)

            output[x,y] = grayscale(MAX - (score * MAX).round)
            diff << score
          end
        end
      end

      pixels_total = images.first.pixels.length
      pixels_changed = diff.length
      pixels_changed_percentage = (diff.inject {|sum, value| sum + value} / images.first.pixels.length) * 100

      filename = "#{name}-color_difference.png"
      output.save(filename)
      File.join(
        File.basename(File.dirname(filename)),
        File.basename(filename)
      )
    end
  end
end