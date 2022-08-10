class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      if user
        render json: user.items
      else
        render json: { error: "User not found"}, status: :not_found
      end
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    if params[:id]
      item = Item.find(params[:id])
      if item
        render json: item
      end
    end
  end

  def create
    if params[:user_id]
      item = Item.create(item_params)
      render json: item, status: :created
    end
  end

  private

  def not_found_response
    render json: { error: "Not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end


end
