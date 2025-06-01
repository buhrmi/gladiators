<script>
  import { getContext } from 'svelte';
  const {
    target,
    back,close
  } = $props();

  const { router } = getContext('inertia');
  function attack() {
    router.post("/fights", {
      target_id: target.id
    })
  }
</script>

<main>
  <section class="py-2">
    <h2 class="mb-2">Angriff auf {target.name}</h2>
    <p>
      Es geht heiß her. Plötzlich seht Ihr {target.name} vor Euch stehen, ein {target.race} der {target.level}. Stufe. Er hält ein Schwert in seiner Hand und grinst Euch an.
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