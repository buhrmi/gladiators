<script>
  import { getContext } from 'svelte';
  const {
    target,
    back
  } = $props();

  const { router } = getContext('inertia');
  function attack() {
    router.post("/fights", {
      target_id: target.id
    }, {
      // preserveUrl: false
    })
  }
</script>

<main>
  <section class="py-2">
    <h2 class="mb-2">Wollt Ihr {target.name} angreifen?</h2>
    <p>
      Plötzlich seht Ihr <strong>{target.name}</strong> vor Euch stehen, ein <strong>{target.race} der {target.level}. Stufe</strong>. Sein <strong>Schwert</strong> ist einsatzbereit.
    </p>
    <button onclick={attack} class="btn attack mb-2" data-loader>
      <div class="i-game-icons:sword-brandish w-1.7em h-1.7em"></div>
      <div>Angreifen</div>
    </button>
    <button class="btn nope" onclick={back}>
      <div class="i-healthicons:running-24px w-1.7em h-1.7em scale-x-[-1]"></div>
      Lieber nicht.
    </button>
  </section>
</main>