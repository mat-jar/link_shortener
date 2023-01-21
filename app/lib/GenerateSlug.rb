
class GenerateSlug < ApplicationService

  def call
    generate_string
  end

  private

  attr_reader :length

  def initialize(length = 8)
    @length = length
  end

  def generate_string
    letters = Array('A'..'Z') + Array('a'..'z')
    Array.new(@length) { letters.sample }.join
  end


end
