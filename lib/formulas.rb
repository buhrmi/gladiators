MAX_LEVEL = 99

EXP_TABLE = [].tap do |table|
  for level in 1..MAX_LEVEL
    table[level] = ((1.3 ** (level-1) - 1) * 40).round
  end
end

module Formulas
  def base_hp()
    10
  end

  def hp_per_level()
    2
  end

  def max_hp()
    base_hp() + (self.level * hp_per_level())
  end

  def regenerated_hp()
    [ (current_time() - start_regenerating_at()) * hp_per_second(), 0 ].max
  end

  def hp()
    [ 0, [ self.last_hp + regenerated_hp(), max_hp() ].min ].max
  end

  def hp_percent()
    hp() * 100 / max_hp()
  end

  def hp_per_second()
    1
  end

  def alive()
    hp() > 0
  end

  def resurrection_wait_time()
    30
  end

  def regen_wait_time()
    5
  end

  def remaining_regen_wait_time()
    start_regenerating_at() - current_time()
  end

  def start_regenerating_at()
    if self.last_hp <= 0
      self.last_hp_updated_at + resurrection_wait_time()
    else
      self.last_hp_updated_at + regen_wait_time()
    end
  end

  def ressurection_in()
    if self.last_hp <= 0
      [ start_regenerating_at() - current_time(), 0 ].max()
    else
      0
    end
  end

  def current_time()
    Time.current.to_f
  end

  def exp_on_this_level()
    self.exp - (EXP_TABLE[self.level] || 0)
  end

  def exp_to_next_level()
    (EXP_TABLE[self.level + 1] || 0) - EXP_TABLE[self.level]
  end

  def exp_reward()
    reward = (exp_to_next_level() ** 0.7).round
    reward /= 2 if hp() < max_hp()
    reward = (reward * (hp().to_f / max_hp())).floor
    reward
  end

  def coppers_reward()
    min = 4 * (self.level + 1) / 2
    max = 6 * (self.level + 1) / 2
    reward = rand(min..max)
    reward /= 2 if hp() < max_hp()
    reward = (reward * (hp().to_f / max_hp())).floor
    reward
  end
end
