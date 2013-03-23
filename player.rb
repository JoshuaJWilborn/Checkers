#!/bin/env ruby
# encoding: utf-8

class Player
  attr_reader :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end
