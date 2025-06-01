<script>
  const {
    attacker,
    target
  } = $props();
</script>

<main>
  <section  class="py-2">
    <h2 class="mb-2">
      {attacker.name} greift {target.name} an!
    </h2>
  </section>
</main>