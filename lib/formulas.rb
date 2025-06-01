module Formulas
  def hp
    base_hp + (level * hp_per_level)
  end

  def base_hp
    10
  end

  def hp_per_level
    2
  end
end
