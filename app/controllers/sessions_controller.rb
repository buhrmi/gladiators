class SessionsController < ApplicationController
  def new
    if params[:provider]
      # Just render the ERB template that automatically makes a POST request to /auth/:provider
      render layout: false
    end
  end

  def create
    request.env["omniauth.auth"]
    sdfsdf
  end

  def destroy
    session[:user_id] = nil
    flash[:just_logged_out] = true
    flash.now[:notice] = "You have been logged out."
  end
end
