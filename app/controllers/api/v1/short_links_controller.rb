class Api::V1::ShortLinksController < ApplicationController
  before_action :set_short_link, only: %i[ show update destroy ]

  def redirect
    slug = params[:slug]
    original_url = ShortLink.where(slug: slug).first&.original_url

    if original_url

      redirect_to original_url, allow_other_host: true

    else
      render json: { message: "Short link you provided is wrong" }, status: :not_found
    end
  end

  # GET /short_links
  def index
    short_links = ShortLink.all

    render json: short_links
  end

  # GET /short_links/1
  def show
    render json: @short_link, methods: [:short_url], status: :ok
  end

  # POST /short_links
  def create
    short_link = ShortLink.new(short_link_params)

    if short_link_params[:slug]
      if slug_exists?(short_link_params[:slug])
        render json: { message: "Given slug is already used" }, status: :unprocessable_entity and return
      end
    else
      begin
        random_slug = GenerateSlug.call
      end while slug_exists?(random_slug)

      short_link.slug = random_slug
    end
    if short_link.save
      render json: short_link, only: [:original_url], methods: [:short_url], status: :created
    else
      render json: {:invalid_short_link => short_link, :errors =>  short_link.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /short_links/1
  def update

    if short_link_params[:slug]
      if slug_exists?(short_link_params[:slug])
        render json: { message: "Given slug is already used" }, status: :unprocessable_entity and return
      end
    end

    if @short_link.update(short_link_params)
      render json: @short_link
    else
      render json: @short_link.errors, status: :unprocessable_entity
    end
  end

  # DELETE /short_links/1
  def destroy
    @short_link.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_short_link
      #@short_link = ShortLink.find(params[:id])
      if !(search_short_link_params[:original_url] || search_short_link_params[:slug] || search_short_link_params[:short_url])
        render json: { message: "You need to provide original_url, slug or short_url as a query parameter" },
        status: :unprocessable_entity and return
      end

      @short_link = ShortLink.find_by(original_url: search_short_link_params[:original_url])

      if !@short_link
        @short_link = ShortLink.find_by(slug: search_short_link_params[:slug])
      end

      if !@short_link
        slug = search_short_link_params[:short_url].split("/").last
        @short_link = ShortLink.find_by(slug: slug)
      end

      if !@short_link
        render json: { message: "No record with given parameter(s)" }, status: :unprocessable_entity and return
      end
    end

    def short_link_params
      params.require(:short_link).permit(:original_url, :slug)
    end

    def slug_exists?(slug)
      ShortLink.exists?(:slug => slug)
    end

    def search_short_link_params
      params.fetch(:short_link, {}).permit(:original_url, :slug, :short_url)
    end
end
