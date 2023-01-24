require "nokogiri"
require "selenium-webdriver"
require "httparty"

class FetchOGTags < ApplicationService

  def call
    fetch_og_tags
  end

  private

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def fetch_og_tags
    og_tags = parse_page(fetch_with_httparty)
    if og_tags.empty?
      og_tags = parse_page(fetch_with_selenium)
    end
    return og_tags
  end

  def parse_page(html)
    hash = Hash.new
    page_body = Nokogiri::HTML.parse(html)
    page_body.css('meta').each do |m|
      if m.attribute('property') && m.attribute('property').to_s.match(/\Aog:(.+)\z/i)
        hash[m.attribute('property').value] = m.attribute('content').value
      end
    end
    hash
  end

  def fetch_with_selenium
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.manage.timeouts.page_load = 10
    driver.get @url
    html = driver.page_source
  end

  def fetch_with_httparty
    response = HTTParty.get(@url, timeout: 3)
    html = response.body
  end

end
