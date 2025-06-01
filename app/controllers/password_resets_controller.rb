class PasswordResetsController < ApplicationController
  before_action :launch_in_modal

  def new
  end

  def create
    user = current_user || User.verified.find_by_email(params[:email])
    user.try(:send_password_reset)
  end

  def show
    user = User.find_signed(params[:id], purpose: "password_reset")
    @id = params[:id]
    unless user
      flash[:error] = "This link is invalid or has expired."
      redirect_to new_session_path
    end
  end

  def destroy
    user = User.find_signed(params[:id], purpose: "password_reset")
    if user
      user.password = params[:password]
      user.password_digest_will_change!
      user.save!
    else
      flash[:error] = "This link is invalid or has expired."
      redirect_to new_session_path
    end
  end
end
