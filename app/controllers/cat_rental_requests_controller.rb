class CatRentalRequestsController < ApplicationController
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
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    redirect_to cat_url(Cat.find(@cat_rental_request.cat.id))
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url(Cat.find(request_params[:cat_id]))
  end

  private
  def request_params
    params.require(:cat_rental_request).permit(
    :cat_id, :start_date, :end_date)
  end
end
