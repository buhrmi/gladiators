class EmailVerificationsController < ApplicationController
  def show
    user = User.find_by(email_verification_token: params[:id])
    if user
      user.update!(email_verified: true)
    else
      flash[:alert] = "Invalid or expired verification link."
      redirect_to root_path
    end
  end

  def new
  end
end
