class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present? && url_valid?(value)
      record.errors.add(attribute, "is not a valid HTTP URL")
    end
  end

  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end

end
