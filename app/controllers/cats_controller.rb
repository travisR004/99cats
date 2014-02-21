class CatsController < ApplicationController
  before_action :get_cat, only: [:show, :edit, :update, :destroy]
  before_action :owns_cat, only: [:edit, :update, :destroy]
  before_action :user_logged_in, only: [:create]
  def index
    @cats = Cat.all
  end

  def show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def user_logged_in
    redirect_to root_url unless logged_in?
  end

  def owns_cat
    get_cat
    redirect_to cats_url unless @cat.user_id == current_user.id
  end

  def get_cat
    @cat = Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :name, :sex, :profile)
  end
end
