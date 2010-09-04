#!/usr/bin/ruby

require 'rubygems'
require 'RMagick'

class TShirt

  module RMagick
    include Magick
  end

  def self.image(lines, title)
    image = RMagick::Image.new(800, 800) {
      self.background_color = "black"
    }

    text = RMagick::Draw.new

    text.annotate(image, 780, 180, 16, 16, title) {
      self.fill = 'white'
      self.pointsize = 48
      self.gravity = RMagick::NorthGravity
    }

    lines.each_with_index do |line, i|
      text.annotate(image, 780, 32, 10, (i * 32) + 256, line[0]) {
        self.fill = 'white'
        self.pointsize = 20
        self.gravity = RMagick::WestGravity
      }
     text.annotate(image, 780, 32, 10, (i * 32) + 256, line[1]) {
        self.fill = 'white'
        self.pointsize = 20
        self.gravity = RMagick::EastGravity
      }
    end

    sk_logo = RMagick::Image.read('/home/phil/shirtkick/public/images/songkick.png')

    puts sk_logo.inspect

    text.composite(334, 700, 133, 37, sk_logo[0])

    puts text.inspect 

    text.draw(image)

    image.write('image.png')
  end
end
