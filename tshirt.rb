#!/usr/bin/ruby

require 'rubygems'
require 'RMagick'

module RMagick
  include Magick
end

image = RMagick::Image.new(640, 640) {
  self.background_color = "black"
}

text = RMagick::Draw.new

dates = 
  [
   'Date1',
   'Date2',
   'Date3',
   'Date4',
   'Date5',
   'Date6',
   'Date7',
   'Date8',
   'Date9',
   'Date10'
  ]

dates.each_with_index do |date, i|
  text.annotate(image, 620, 32, 10, (i * 32) + 1, date) {
    self.fill = 'white'
    self.pointsize = 24
    self.gravity = RMagick::NorthGravity
  }
end

image.write('image.png')
