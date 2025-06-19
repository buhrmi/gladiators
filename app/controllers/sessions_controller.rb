class SessionsController < ApplicationController
  def new
    if params[:provider]
      # Just render the ERB template that automatically makes a POST request to /auth/:provider
      render layout: false
    else
      launch_in_modal
    end
  end

  def create
    auth = request.env["omniauth.auth"]

    char = Character.find_or_create_by(discord_user_id: auth.uid)
    session[:character_id] = char.id

    render layout: false
  end

  def destroy
    session[:character_id] = nil
    session[:discord] = nil
    flash[:just_logged_out] = true
    flash[:notice] = "Ihr habt Euch erfolgreich ausgeloggt. Bis bald!"
    redirect_back
  end
end
