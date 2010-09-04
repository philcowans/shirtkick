#!/usr/bin/ruby

require 'rubygems'
require 'RMagick'

class TShirt

  module RMagick
    include Magick
  end

  def self.image(lines)
    image = RMagick::Image.new(640, 640) {
      self.background_color = "black"
    }

    text = RMagick::Draw.new

    lines.each_with_index do |line, i|
      text.annotate(image, 620, 32, 10, (i * 32) + 1, line) {
        self.fill = 'white'
        self.pointsize = 24
        self.gravity = RMagick::NorthGravity
      }
    end

    image.write('image.png')
  end
end