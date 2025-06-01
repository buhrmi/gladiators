class FightsController < ApplicationController
  def new
    @panes = [ { src: "/" } ]
    @target = Character.find_by(id: params[:target_id])
  end

  def create
    attacker = current_character
    target = Character.find(params[:target_id])

    if rand(1..100) <= 50
      attacker.update! last_hp: 0
    else
      target.update! last_hp: 0
    end

    @attacker = attacker.as_json(Character::JSON_OPTIONS)
    @target = target.as_json(Character::JSON_OPTIONS)
  end
end
