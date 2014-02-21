class SessionsController < ApplicationController
  before_action :require_user, only: [:new, :create]

  def require_user
    redirect_to cats_url if logged_in?
  end

  def new
    render :new
  end

  def create
    get_user
    if @user
      login!
      redirect_to cats_url
    else
      flash.now[:error] = ["Invalid Credentials"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private
  def get_user
    @user = User.find_by_credentials(params[:user])
  end

end