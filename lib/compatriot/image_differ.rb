require 'chunky_png'
include ChunkyPNG::Color

module Compatriot
  class ImageDiffer

    def self.diff(results)

      images = results.map{|r| ChunkyPNG::Image.from_file(r) }

      puts "*****************************"
      puts "#{results.first}"
      puts "#{results.last}"

      puts "-----------------------------"
      puts "Same pixels exactly"
      self.same_pixels_exactly(images, results.first)

      puts "-----------------------------"
      puts "Color difference"
      self.color_difference(images, results.first)

    end

    def self.same_pixels_exactly(images, name)
      output = ChunkyPNG::Image.new(images.first.width, images.last.width, WHITE)
      diff = []

      images.first.height.times do |y|
        images.first.row(y).each_with_index do |pixel, x|
          output[x,y] = pixel
          diff << [x,y] unless pixel == images.last[x,y]
        end
      end

      puts "pixels (total):     #{images.first.pixels.length}"
      puts "pixels changed:     #{diff.length}"
      puts "pixels changed (%): #{(diff.length.to_f / images.first.pixels.length) * 100}%"


      x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

      output.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))
      output.save("#{name}-same_exactly.png")
    end

    def self.color_difference(images, name)
      output = ChunkyPNG::Image.new(images.first.width, images.last.width, WHITE)
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

      puts "pixels (total):     #{images.first.pixels.length}"
      puts "pixels changed:     #{diff.length}"
      puts "image changed (%): #{(diff.inject {|sum, value| sum + value} / images.first.pixels.length) * 100}%"

      output.save("#{name}-color_difference.png")

    end
  end
end