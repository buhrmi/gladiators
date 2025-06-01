<script>
  const { fight } = $props();

  const attacker = fight.attacker;
  const target = fight.target;
  const attacker_won = fight.won;

  const participants = [attacker, target]
  
  function localizeLog(log) {
    const attacker = participants[log.attacker_idx];
    const target = participants[log.target_idx];

    if (log.event == "attack") {
      return `${attacker.name} greift ${target.name} mit Schwert an.`;
    }
    else if (log.event == "damage") {
      return `${target.name} erleidet ${log.damage} ${log.dmg_type}.`;
    }
  }
</script>

<main>
  <section class="py-2">
    <h2></h2>
  </section>
  <section>
    {#each fight.logs as log}
      <p>{localizeLog(log)}</p>
    {/each}
  </section>
</main>