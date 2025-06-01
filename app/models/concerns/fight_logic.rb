module FightLogic
  extend ActiveSupport::Concern
  include Properties

  def exp_reward
    (exp_to_next_level ** 0.7).round
  end

  def coppers_reward
    min = 6 * level / 2
    max = 9 * level / 2
    rand(min..max)
  end
end
