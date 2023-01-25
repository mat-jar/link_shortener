class Api::V1::UsersController < ApplicationController

  before_action :authorize, except: :create

  def index
    users = User.all
    render json: users, status: :ok
  end

  def show
    render json: @current_user, include: [:short_links => {:only => [:original_url], methods: [:short_url] }], status: :ok
  end


  def create
    user = User.new(user_params)
    if user.save
      render json: user, only: [:id, :email, :created_at], status: :created
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user, only: [:id, :email, :created_at, :updated_at], status: :ok
    else
      render json: @current_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
