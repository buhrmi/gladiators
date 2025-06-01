class Fight < ApplicationRecord
  JSON_OPTIONS = {
    only: [ :id, :logs, :won, :created_at ],
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

  def execute!
    Current.fight = self

    while participants.all?(&:alive)
      attack(0, 1)
      if participants.all?(&:alive)
        attack(1, 0)
      end
    end

    self.won = attacker.alive

    loser.update! last_hp: loser.hp
    winner.update!(
      last_hp: winner.hp,
      exp: winner.exp + loser.exp_reward,
      coppers: winner.coppers + loser.coppers_reward
    )
    self.save!
  end

  def winner
    self.won ? attacker : target
  end

  def loser
    self.won ? target : attacker
  end

  def log(json)
    self.logs << json
  end

  def attack(attacker_idx, target_idx)
    attacker = participants[attacker_idx]
    target = participants[target_idx]
    log({ event: "attack", attacker_idx:, target_idx: })
    damage = rand(3..6)
    target.hp -= damage
    log({ event: "damage", damage: damage, target_idx: })
  end
end
