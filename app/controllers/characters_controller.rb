class CharactersController < ApplicationController
  def index
    @characters = Character.order("exp desc").with_attached_portrait.as_json(Character::JSON_OPTIONS)
  end

  def show
    @panes = [ { src: "/" } ]
    @character = Character.find(params[:id]).as_json(Character::JSON_OPTIONS)
  end

  def new
    launch_in_modal
    @return_to = session[:return_to]
    @discord = session[:discord]
  end

  def create
    return if session[:character_id]
    character = Character.new(create_params)
    character.discord_user_id = session[:discord]["uid"]
    character.name = session[:discord]["info"]["name"]
    character.email = session[:discord]["info"]["email"]
    if session[:discord]["info"]["image"]
      image = URI.parse(session[:discord]["info"]["image"]).open
      character.portrait.attach(io: image, filename: "portrait.png", content_type: "image/png")
    end
    character.save!

    @return_to = session[:return_to]
    session[:character_id] = character.id
  end

  private
  def create_params
    params.require(:character).permit(:race)
  end
end
