class CharacterItem < ApplicationRecord
  belongs_to :character
  belongs_to :item

  delegate_missing_to :item
end
