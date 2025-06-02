class CharactersController < ApplicationController
  def index
    @characters = Character.all.as_json(Character::JSON_OPTIONS)
  end

  def show
    @panes = [ { src: "/" } ]
    @character = Character.find(params[:id]).as_json(Character::JSON_OPTIONS)
  end

  def new
    launch_in_modal
  end

  def create
    @character = Character.create!(create_params)
    session[:character_id] = @character.id
  end

  private
  def create_params
    params.require(:character).permit(:name, :race)
  end
end
