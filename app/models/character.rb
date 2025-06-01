class Character < ApplicationRecord
  include Properties

  JSON_OPTIONS = {
    only: [ :id, :name, :level, :race, :last_hp, :last_hp_updated_at, :exp ]
  }

  PRIVATE_JSON_OPTIONS = {
    only: JSON_OPTIONS[:only] + [ :coppers ]
  }

  has_one_attached :portrait

  belongs_to :user, optional: true

  has_many :character_items, dependent: :destroy
  has_many :items, through: :character_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 24 }
  validates :race, presence: true, inclusion: { in: %w[human elf dwarf orc] }

  after_update_commit :broadcast_update

  def broadcast_update
    CharacterChannel[self].store("character").merge saved_changes.transform_values(&:last)
  end

  def last_hp=(val)
    self[:last_hp] = val
    self.last_hp_updated_at = current_time
  end
end
