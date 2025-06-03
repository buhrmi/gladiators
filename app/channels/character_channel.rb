class CharacterChannel < ApplicationCable::Channel
  def subscribed
    character = GlobalID::Locator.locate_signed(params[:character_sgid])
    state("updates").push(character.as_json(Character::PRIVATE_JSON_OPTIONS))
    state("last_attacks").set(character.attacking_fights.pluck(:target_id, :created_at).to_h.transform_values(&:to_i))
    state("character_id").set(character.id)
    stream_for(character)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
