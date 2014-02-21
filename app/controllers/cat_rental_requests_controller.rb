class CatRentalRequestsController < ApplicationController
  before_action :user_logged_in, only: [:create, :approve, :deny]
  before_action :get_cat_request, only: [:approve, :deny, :owns_cat]
  before_action :get_cat, only: [:owns_cat, :deny, :approve]
  before_action :owns_cat, only: [:approve, :deny]


  def new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(request_params)

    if @cat_rental_request.save
      redirect_to cat_url(Cat.find(request_params[:cat_id]))
    else
      flash.now[:error] = @cat_rental_request.errors.full_messages
      render :new
    end
  end

  def approve
    @cat_rental_request.approve!
    redirect_to cat_url(@cat)
  end

  def deny
    @cat_rental_request.deny!
    redirect_to cat_url(@cat)
  end

  private
  def user_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def owns_cat
    redirect_to cats_url unless @cat.user_id == current_user.id
  end

  def get_cat_request
    @cat_rental_request = CatRentalRequest.find(params[:id])
  end

  def get_cat
    @cat = Cat.find(@cat_rental_request.cat.id)
  end

  def request_params
    params.require(:cat_rental_request).permit(
    :cat_id, :start_date, :end_date)
  end
end
