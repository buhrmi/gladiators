<script>
  import { ConfettiExplosion } from 'svelte-confetti-explosion'
  import { augment } from '~/lib/character.svelte'
  
  const { 
    fight
  } = $props();

  // const attacker = augment(fight.attacker);
  // const target = augment(fight.target);
  const { attacker, target } = fight
  const rewards = fight.metadata.rewards;

  const participants = [attacker, target]
  
  function localizeLog(log) {
    if (log.event == "attack") {
      const attacker = participants[log.attacker_idx];
      const target = participants[log.target_idx];
      return `${attacker.name} greift ${target.name} mit Schwert an.`;
    }
    else if (log.event == "damage") {
      const target = participants[log.target_idx];
      return `${target.name} erleidet ${log.damage} ${log.dmg_type}.`;
    }
    else if (log.event = "level_up") {
      const char = participants[log.char_idx];
      return `${char.name} steigt auf und erreicht Stufe ${log.new_level}.`;
    }
  }
</script>

{#if fight.won}
 <div class="absolute inset-0 flex justify-center z-10 pointer-events-none overflow-hidden">
   <ConfettiExplosion />
 </div>
{/if}

<main>
  <section class="py-2">
    <h2>
      {#if fight.won}
        Sieg
      {:else}
        Niederlage
      {/if}
    </h2>
    {#each rewards as reward, index}
      {@const char = participants[index]}
      {#each Object.entries(reward) as [type, amount]}
        <p>
          {char.name} erhält {amount} {type}.
        </p>
      {/each}
    {/each}
    {#each participants as participant}
      {#if participant.hp <= 0}
        <p>
          {participant.name} stirbt und wird in {Math.ceil(participant.ressurection_in)} Sekunden wiederbelebt.
        </p>
      {/if}
    {/each}
  </section>
  <section>
    {#each fight.logs as round, index}
      <h3>Runde {index + 1}</h3>
      {#each round as log}
        <p>{localizeLog(log)}</p>
      {/each}
    {/each}
  </section>
</main>