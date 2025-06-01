<script>
  const {
    characters
  } = $props();

</script>

<main>
  <section>
    <h1 class="mt-4">Gladiators Reloaded</h1>
  </section>
  <section>
    <p>
      Ihr betretet die Arena. Ihr könnt Euch nicht erinnern, warum Ihr hier seid. Doch im Getümmel könnt Ihr folgende Charaktere erkennen:
    </p>
    <table>
      <thead>
        <tr>
          <th>Level</th>
          <th>Name</th>
          <th>Rasse</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        {#each characters as character}
          <tr>
            <td>{character.level}</td>
            <td><a href="/characters/{character.id}" use:navstack={{
              initialComponent: import("~/pages/characters/show.svelte"),
              character
            }}>{character.name}</a></td>
            <td>{character.race}</td>
          </tr>
        {/each}
      </tbody>
    </table>
    
  </section>
</main>