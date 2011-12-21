require 'chunky_png'
include ChunkyPNG::Color

module Compatriot
  class ImageDiffer

    attr_reader :diffs

    def initialize(params = {})
      @paths    = params[:paths]
      @browsers = params[:browsers]
      @strategy = params[:strategy] || :color_difference
      @diffs    = {}
    end

    def compute!
      @paths.map do |path|
        images_to_diff = @browsers.map { |b| b.screenshot_for(path) }
        @diffs[path] = diff(images_to_diff)
      end
    end

    def diff(results)
      images = results.map{|r| ChunkyPNG::Image.from_file(r) }
      self.send(@strategy, images.first, images.last, results.first)
    end

    def same_pixels_exactly(image1, image2, name)
      output = ChunkyPNG::Image.new(image1.width, image2.height, WHITE)
      diff = []

      each_pixel(image1) do |x, y|
        pixel1 = image1[x, y]
        pixel2 = image2[x, y]
        output[x,y] = pixel1
        diff << [x,y] unless pixel1 == pixel2
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

    def color_difference(image1, image2, name)
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

      filename = "#{name}-color_difference.png"
      output.save(filename)
      File.join(
        File.basename(File.dirname(filename)),
        File.basename(filename)
      )
    end

    def color_difference_of_pixels(pixel1, pixel2)
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

    def each_pixel(image)
      image.width.times do |x|
        image.height.times do |y|
          yield(x, y)
        end
      end
    end
  end
end