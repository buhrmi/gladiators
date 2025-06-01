class Character < ApplicationRecord
  JSON_OPTIONS = {
    only: [ :id, :name, :level, :race ]
  }

  belongs_to :user, optional: true

  has_many :character_items, dependent: :destroy
  has_many :items, through: :character_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 24 }
  validates :race, presence: true, inclusion: { in: %w[human elf dwarf orc] }
end
