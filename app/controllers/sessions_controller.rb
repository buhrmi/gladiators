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
    session[:discord] = {
      uid: auth.uid,
      info: {
        name: auth.info.name,
        email: auth.info.email,
        image: auth.info.image
      }
    }
    char = Character.find_by(discord_user_id: auth.uid)
    if char
      session[:character_id] = char.id
    else
      flash[:notice] = "Diesem Discord-Account ist kein Charakter zugeordnet."
    end
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
