class FightsController < ApplicationController
  def new
    @panes = [ { src: "/" } ]
    @target = Character.find_by(id: params[:target_id])
  end

  def create
    unless current_character
      session[:return_to] = new_fight_path(target_id: params[:target_id])
      return redirect_to new_character_path
    end
    sleep 1 # hihi
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
