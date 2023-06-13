
class RedirectToLink < ApplicationService

  delegate :response, :redirect_to, to: :controller

  attr_reader :controller, :short_link

  def initialize(controller, short_link)
    @controller = controller
    @short_link = short_link
  end

  def call
    redirect
  end

  private

  def redirect
    use_short_link
    compose_reponse_body
  end

  def use_short_link
    original_url = @short_link.original_url
    @short_link.use_counter += 1
    @short_link.last_use = Time.now.to_i
    @short_link.save!
    redirect_to original_url, allow_other_host: true
  end

  def compose_reponse_body
    og_tags = @short_link.og_tags
    if !og_tags.empty?
      response_head = "<html><head>"
      og_tags.each do |og_tag|
        response_head += %Q|<meta property="#{og_tag.property}" content="#{og_tag.content}" />|
      end
      response_head += "</head><body>"
      response.body.gsub!(/<html><body>/, response_head)
    end
  end

end
