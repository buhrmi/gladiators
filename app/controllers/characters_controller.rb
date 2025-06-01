class CharactersController < ApplicationController
  def index
  end

  def new
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
