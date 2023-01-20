class Api::V1::ShortLinksController < ApplicationController
  before_action :set_short_link, only: %i[ show update destroy ]

  # GET /short_links
  def index
    @short_links = ShortLink.all

    render json: @short_links
  end

  # GET /short_links/1
  def show
    render json: @short_link
  end

  # POST /short_links
  def create
    @short_link = ShortLink.new(short_link_params)

    if @short_link.save
      render json: @short_link, status: :created
    else
      render json: @short_link.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /short_links/1
  def update
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
      @short_link = ShortLink.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def short_link_params
      params.require(:short_link).permit(:original_url, :slug)
    end
end
