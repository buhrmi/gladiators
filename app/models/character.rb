class Character < ApplicationRecord
  include FightLogic

  JSON_OPTIONS = {
    only: [ :id, :name, :level, :race, :last_hp, :last_hp_updated_at, :exp ]
  }

  PRIVATE_JSON_OPTIONS = {
    only: JSON_OPTIONS[:only] + [ :coppers ]
    # methods: [ :exp_on_this_level, :exp_to_next_level ]
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

  def exp=(new_exp)
    puts "Setting exp to #{new_exp} for character #{self.name} (#{self.id})"
    self[:exp] = new_exp
    self.level = calculate_level
  end
end
