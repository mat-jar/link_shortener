require "nokogiri"
require "selenium-webdriver"
require "httparty"

class FetchOGTags < ApplicationService

  def call
    set_og_tags
  end

  private

  attr_reader :url

  def initialize(short_link)
    @short_link = short_link
    @url = short_link.original_url
  end

  def set_og_tags
    begin
      og_tags_hash = fetch_og_tags
    rescue Selenium::WebDriver::Error::UnknownError, Selenium::WebDriver::Error::TimeoutError, HTTParty::Error, OpenSSL::SSL::SSLError, SocketError => e
      @short_link.errors.add("og_tags", e.message)
    else
      if !og_tags_hash.empty?
        SaveOGTags.call(@short_link, og_tags_hash)
      else
        @short_link.errors.add("og_tags", "Connection was established but couldn't fetch any OG tags")
      end
    end
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
