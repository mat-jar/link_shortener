
class SetSlug < ApplicationService

  delegate :render, to: :controller

  attr_reader :controller, :slug

  def initialize(controller, slug)
    @controller = controller
    @slug = slug
  end

  def call
    set_slug
  end

  private

  def set_slug
    if @slug
      verify_slug
    else
      begin
        @slug = GenerateSlug.call
      end while slug_exists?
    end

    return @slug
  end

  def verify_slug
    if slug_exists?
      render json: { message: "Given slug is already used" }, status: :unprocessable_entity and return
    end
  end

  def slug_exists?
    ShortLink.exists?(:slug => @slug)
  end

end
