class Fight < ApplicationRecord
  JSON_OPTIONS = {
    only: [ :id, :logs, :won, :created_at, :metadata ],
    include: {
      attacker: Character::JSON_OPTIONS,
      target: Character::JSON_OPTIONS
    }
  }

  belongs_to :attacker, class_name: "Character", foreign_key: "attacker_id"
  belongs_to :target, polymorphic: true


  # TODO: take snapshots of characters before the fight starts
  def participants
    [ attacker, target ]
  end

  after_create_commit :broadcast_attack_block

  def broadcast_attack_block
    CharacterChannel[self.attacker].state([ :last_attacks, self.target_id ]).set(self.created_at.to_i)
  end

  def round
    @round || 0
  end

  def execute!
    last_attack = attacker.attacking_fights.where(target_id: target.id).order(created_at: :desc).first
    if last_attack && attacker.time_to_next_attack(last_attack.created_at.to_i) > 0
      wait_time = ActiveSupport::Duration.build(attacker.time_to_next_attack(last_attack.created_at.to_i).ceil).inspect
      raise Errors::GameError.new("fight.attack_too_soon",
        wait_time: wait_time,
        target_name: target.name
      )
    end
    if !attacker.alive
      raise Errors::GameError.new("fight.attacker_dead")
    end
    if !target.alive
      raise Errors::GameError.new("fight.target_dead", target_name: target.name)
    end
    if attacker.id == target.id
      raise Errors::GameError.new("fight.cannot_attack_self")
    end


    self.rewards[0] = {
      exp: participants[1].exp_reward,
      coppers: participants[1].coppers_reward
    }

    self.rewards[1] = {
      exp: participants[0].exp_reward,
      coppers: participants[0].coppers_reward
    }

    while participants.all?(&:alive)
      @round = @round ? @round + 1 : 0
      attack(0, 1)
      if participants.all?(&:alive)
        attack(1, 0)
      end
    end

    # if you die u get nothing
    rewards[0] = {} unless participants[0].alive
    rewards[1] = {} unless participants[1].alive

    self.won = attacker.alive
    participants.each_with_index do |participant, idx|
      participant.last_hp = participant.hp
      rewards = self.rewards[idx]
      participant.exp += rewards[:exp] if rewards[:exp]
      participant.coppers += rewards[:coppers] if rewards[:coppers]
      participant.save!
      if participant.saved_change_to_level?
        rewards[:level] = 1
        log({ event: "level_up", char_idx: idx, new_level: participant.level })
      end
    end

    self.save!
  end

  # rewards by participant index
  def rewards
    metadata["rewards"] ||= []
  end

  def winner
    self.won ? attacker : target
  end

  def loser
    self.won ? target : attacker
  end

  def log(json)
    self.logs[round] ||= []
    self.logs[round] << json
  end

  def attack(attacker_idx, target_idx)
    attacker = participants[attacker_idx]
    target = participants[target_idx]
    log({ event: "attack", attacker_idx:, target_idx: })
    min_damage = attacker.min_damage
    max_damage = attacker.max_damage
    damage = rand(min_damage..max_damage)
    target.hp -= damage
    log({ event: "damage", damage: damage, dmg_type: "slash", target_idx: })
  end
end
