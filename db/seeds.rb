  # if Rails.env.development?
  orki = Character.where(
    name: "Orki",
    race: "orc"
  ).first_or_create!
  elfie = Character.where(
    name: "Elfie",
    race: "elf"
  ).first_or_create!
  dwarfy = Character.where(
    name: "Dwarfy",
    race: "dwarf"
  ).first_or_create!
# end
