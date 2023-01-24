class OgTag < ApplicationRecord
  belongs_to :short_link
  validates :property, :content, presence: true
  validates :property, uniqueness: { scope: :short_link_id, message: "Can't have two properties with the same name for one short link" }
  validates_format_of :property, :with => /\Aog:(.+)\z/i

end
