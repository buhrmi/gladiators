module Methods
  def attack_forbidden_duration
    60
  end

  def remaining_attack_forbidden(time)
    time + attack_forbidden_duration - self.current_time
  end

  def attack_forbidden(time)
    remaining_attack_forbidden(time) > 0
  end
end
