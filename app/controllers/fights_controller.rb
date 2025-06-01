class FightsController < ApplicationController
  def new
    @panes = [ { src: "/" } ]
    @target = Character.find_by(id: params[:target_id])
  end

  def create
    fight = Fight.new(
      attacker: current_character,
      target: Character.find_by(id: params[:target_id])
    )
    fight.execute!
    redirect_to fight
  end

  def show
    @fight = Fight.find(params[:id]).as_json(Fight::JSON_OPTIONS)
  end
end
