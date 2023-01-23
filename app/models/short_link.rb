class ShortLink < ApplicationRecord
  validates :original_url, url: true
  validates :original_url, :slug,  presence: true
  validates :slug, uniqueness: { message: "You can't have two identical slugs" }
  attribute :use_counter, default: 0
  validates_format_of :slug, :with => /\A[a-z]+(?:-[a-z]+)*\z/i

  def short_url
    return nil unless persisted?
    "#{ENV["HOST_NAME"]}/#{slug}" # http://localhost:3000/abc or https://xyz.herokuapp.com/abc
  end

  def formatted_last_use
    return nil unless persisted?
    if last_use
      Time.at(last_use).strftime("%d/%m/%Y %k:%M")
    else
      return "The link hasn't been used yet"
    end
  end

end
