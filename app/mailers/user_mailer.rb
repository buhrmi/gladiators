class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verification_email.subject
  #
  def verification_email(user, token)
    @user = user
    @verification_url = email_verification_url(token)
    mail to: @user.email, subject: "Welcome to Gladi! Please verify your email address"
  end

  def password_reset
    @user = params[:user]
    mail to: @user.email, subject: "🔐 Set a new password"
  end
end
