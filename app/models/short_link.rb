class ShortLink < ApplicationRecord
  validates :original_url, url: true
  validates :original_url, :slug,  presence: true
  validates :slug, uniqueness: { message: "You can't have two identical slugs" }
  attribute :counter, default: 0
  validates_format_of :slug, :with => /\A[a-z]+(?:-[a-z]+)*\z/i

  def short_url
    return nil unless persisted?
    "#{ENV["HOST_NAME"]}/#{slug}" # http://localhost:3000/abc or https://xyz.herokuapp.com/abc
  end

end
