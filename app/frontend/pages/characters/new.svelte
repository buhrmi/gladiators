<script>
  import Input from '~/components/Input.svelte';
  import { useForm } from "inertiax-svelte"

  const character = useForm({
    name: '',
    race: '',
  });
</script>

<header>
  Neuer Charakter
</header>
<main>
  <section>
    <h2 class="mb-4">Willkommen in der Arena</h2>
    <p>
      Wählt einen angsteinflößenden Namen, der Eure Gegner erzittern lässt.
    </p>
    <Input label="Name" bind:value={$character.name} bind:error={$character.errors.name} placeholder="Pupsi der Zerstörer" />

    <select bind:value={$character.race}>
      <option value="" disabled selected>Rasse wählen</option>
      <option value="human">Mensch</option>
      <option value="orc">Ork</option>
      <option value="elf">Elf</option>
      <option value="dwarf">Zwerg</option>
    </select>
  </section>
</main>

<footer>
  <section>
    <button class="btn primary" data-loader on:click={() => $character.post('/characters')}>
      Erstellen
    </button>
  </section>
</footer>