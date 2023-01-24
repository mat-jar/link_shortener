class Api::V1::ShortLinksController < ApplicationController
  before_action :set_short_link, only: %i[ show update destroy fetch_og_tags]

  def redirect
    slug = params[:slug]
    short_link = ShortLink.where(slug: slug).first
    if short_link
      RedirectToLink.call(self, short_link)

    else
      render json: { message: "Short link you provided is wrong" }, status: :not_found
    end
  end

  def fetch_og_tags
    begin
      og_tags_hash = FetchOGTags.call(@short_link.original_url)
    rescue Selenium::WebDriver::Error::UnknownError, Selenium::WebDriver::Error::TimeoutError, HTTParty::Error, SocketError => e
      @short_link.errors.add("og_tags", e.message)
    else
      if !og_tags_hash.empty?
        SaveOGTags.call(@short_link, og_tags_hash)
      else
        @short_link.errors.add("og_tags", "Connection was established but couldn't fetch any OG tags")
      end
    end
    if @short_link.errors
      render json: @short_link, only: [:original_url], methods: [:short_url, :errors], status: :unprocessable_entity
    else
      render json: @short_link, only: [:original_url], methods: [:short_url], include: [:og_tags => {:only => [:property, :content] }], status: :created
    end
  end

  def index
    short_links = ShortLink.all
    render json: short_links
  end

  def show
    render json: @short_link, methods: [:short_url, :formatted_last_use], include: [:og_tags => {:only => [:property, :content] }], status: :ok
  end

  def create
    short_link = ShortLink.new(new_short_link_params)

    if new_short_link_params[:slug]
      if slug_exists?(new_short_link_params[:slug])
        render json: { message: "Given slug is already used" }, status: :unprocessable_entity and return
      end
    else
      begin
        random_slug = GenerateSlug.call
      end while slug_exists?(random_slug)

      short_link.slug = random_slug
    end
    if short_link.save
      SaveOGTags.call(short_link, new_og_tags_params)
      render json: short_link, only: [:original_url], methods: [:short_url, :errors], include: [:og_tags => {:only => [:property, :content] }], status: :created
    else
      render json: {:invalid_short_link => short_link, :errors =>  short_link.errors}, status: :unprocessable_entity
    end
  end

  def update

    if update_short_link_params[:slug]
      if slug_exists?(update_short_link_params[:slug])
        render json: { message: "Given slug is already used" }, status: :unprocessable_entity and return
      end
    end

    if @short_link.update(update_short_link_params)
      render json: @short_link, only: [:original_url], methods: [:short_url], status: :ok
    else
      render json: @short_link.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @short_link.destroy
  end

  private
    def set_short_link
      if set_short_link_params
        if !(set_short_link_params[:original_url] || set_short_link_params[:slug] || set_short_link_params[:short_url])
          render json: { message: "You need to provide original_url, slug or short_url as a query parameter" },
          status: :unprocessable_entity and return
        end
      else
        render json: { message: "Provided request parameters are invalid" }, status: :bad_request and return
      end

      @short_link = ShortLink.find_by(original_url: set_short_link_params[:original_url])

      if !@short_link
        @short_link = ShortLink.find_by(slug: set_short_link_params[:slug])
      end

      if !@short_link
        slug = set_short_link_params[:short_url]&.split("/")&.last
        @short_link = ShortLink.find_by(slug: slug)
      end

      if !@short_link
        render json: { message: "No record with given parameter(s)" }, status: :unprocessable_entity and return
      end
    end

    def new_short_link_params
      params.require(:new_short_link).permit(:original_url, :slug)
    end

    def new_og_tags_params
      params.fetch(:new_og_tags, {})
    end

    def slug_exists?(slug)
      ShortLink.exists?(:slug => slug)
    end

    def set_short_link_params
      params.fetch(:short_link, {})&.permit(:original_url, :slug, :short_url)
    end

    def update_short_link_params
      params.fetch(:update_short_link, {})&.permit(:original_url, :slug)
    end
end
