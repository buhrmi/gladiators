if Rails.env.development?
  orki = Character.create!(
    name: "Orki",
    race: "orc"
  )
  elfie = Character.create!(
    name: "Elfie",
    race: "elf"
  )
  dwarfy = Character.create!(
    name: "Dwarfy",
    race: "dwarf"
  )
end
