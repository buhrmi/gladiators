module FightLogic
  extend ActiveSupport::Concern
  include Properties

  def exp_reward
    (exp_to_next_level ** 0.7).round
  end

  def coppers_reward
    min = 4 * (level + 1) / 2
    max = 6 * (level + 1) / 2
    reward = rand(min..max)
    # reward /= 2 if hp < max_hp
    # reward = (reward * (hp.to_f / max_hp)).round
    reward
  end

  def hp=(value)
    self.last_hp = value
    self.last_hp_updated_at = Time.current
  end
end
