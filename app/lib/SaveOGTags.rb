
class SaveOGTags < ApplicationService

    attr_reader :short_link, :og_tags

  def initialize(short_link, og_tags)
    @short_link = short_link
    @og_tags = og_tags
  end

  def call
    save_og_tags
  end

  private

  def save_og_tags
      @og_tags.each_pair do |key, value|
      if key.match?(/\Aog:(.+)\z/i) && @short_link.og_tags.find_by(property: key).nil?
        @og_tag = @short_link.og_tags.new(property: key, content: value)
        @og_tag.save!
      end
    end
  end

end
