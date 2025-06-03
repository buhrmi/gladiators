class Character < ApplicationRecord
  include Formulas

  JSON_OPTIONS = {
    only: [
      :id, :name, :level, :race, :last_hp, :last_hp_updated_at, :exp
    ],
    include: {
      portrait: {}
    }
  }

  PRIVATE_JSON_OPTIONS = {
    only: JSON_OPTIONS[:only] + [ :coppers ]
    # methods: [ :exp_on_this_level, :exp_to_next_level ]
  }

  has_one_attached :portrait

  belongs_to :user, optional: true

  has_many :character_items, dependent: :destroy
  has_many :items, through: :character_items, dependent: :destroy
  has_many :attacking_fights, class_name: "Fight", foreign_key: "attacker_id", dependent: :destroy
  has_many :targeting_fights, class_name: "Fight", foreign_key: "target_id", dependent: :destroy

  validates :name, presence: true, length: { maximum: 24 }
  validates :race, presence: true, inclusion: { in: %w[human elf dwarf orc] }

  after_update_commit :broadcast_update
  after_update_commit :check_level_up

  def check_level_up
    if saved_change_to_level?
      CharacterChannel[self].state("toasts").push({
        type: "level_up",
        message: I18n.t("notifications.level_up.message", level: self.level, name: self.name),
        title: I18n.t("notifications.level_up.title")
      })
    end
  end

  def broadcast_update
    # any updates (possible private) to character channel
    possibly_private_updates = saved_changes.transform_values(&:last)
    CharacterChannel[self].state("updates").push(possibly_private_updates.merge(id: self.id))

    # public updates to arena channel
    updates = {
      exp: self.exp,
      last_hp: self.last_hp,
      last_hp_updated_at: self.last_hp_updated_at,
      level: self.level,
      id: self.id
    }
    ArenaChannel["public"].state("updates").push(updates)
  end

  def exp=(new_exp)
    self[:exp] = new_exp
    self.level = calculate_level
  end

  def calculate_level
    for level in 2..MAX_LEVEL
      return level-1 if self.exp < EXP_TABLE[level]
    end
    MAX_LEVEL
  end

  def hp=(value)
    self.last_hp = value
    self.last_hp_updated_at = Time.current
  end
end
