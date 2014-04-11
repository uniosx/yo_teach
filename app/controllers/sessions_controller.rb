class SessionsController < ApplicationController
  skip_filter :authenticate, only: [:new, :create]
  layout 'authenticate'

  def new
  end

  def create
    user = User.find_by_email params[:log_in][:email]
    if user && user.authenticate(params[:log_in][:password])
      session[:user_id] = user.id
      flash[:notice] = 'Logged in!'
      redirect_to root_url
    else
      flash[:error] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Logged out!'
    redirect_to root_url
  end
end
