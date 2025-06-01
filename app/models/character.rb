class Character < ApplicationRecord
  PRIVATE_JSON_OPTIONS = {
    only: [ :id, :name, :race ]
  }

  validates :name, presence: true, uniqueness: true, length: { maximum: 24 }
  validates :race, presence: true, inclusion: { in: %w[human elf dwarf orc] }
end
