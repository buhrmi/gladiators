class FightsController < ApplicationController
  def new
    @panes = [ { src: "/" } ]
    @target = Character.find_by(id: params[:target_id])
  end

  def create
    attacker = current_character.lock!
    target = Character.find(params[:target_id]).lock!

    if rand(1..100) <= 50
      winner = attacker
      loser = target
    else
      winner = target
      loser = attacker
    end
    loser.update! last_hp: 0
    winner.update!(
      exp: winner.exp + loser.exp_reward,
      coppers: winner.coppers + loser.coppers_reward
    )

    @attacker = attacker.as_json(Character::JSON_OPTIONS)
    @target = target.as_json(Character::JSON_OPTIONS)
  end
end
