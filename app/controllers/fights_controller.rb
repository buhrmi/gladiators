class FightsController < ApplicationController
  def new
    unless session[:character_id]
      return redirect_to new_character_path
    end
    @panes = [ { src: "/" } ]
    @target = Character.find_by(id: params[:target_id])
  end

  def create
    current_character.lock!
    sleep 10
    fight = Fight.new(
      attacker: current_character,
      target: Character.find_by(id: params[:target_id])
      )
    fight.execute!
    redirect_to fight
  end

  def show
    @panes = [ { src: "/" } ]
    @fight = Fight.find(params[:id]).as_json(Fight::JSON_OPTIONS)
  end
end
