class CharacterChannel < ApplicationCable::Channel
  def subscribed
    character = GlobalID::Locator.locate_signed(params[:character_sgid])
    state("character").set character.as_json(Character::PRIVATE_JSON_OPTIONS)
    stream_for character
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
