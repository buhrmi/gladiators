<script>
  import { navstack } from 'navstack'
  
  import character from "~/lib/character.svelte"

  const {
    characters
  } = $props();

  function canAttack(c) {
    return c.id !== $character?.id && c.level <= $character?.level + 5;
  }

</script>

<main>
  <section>
    <h2 class="mt-4">Ihr betretet die Arena</h2>
  </section>
  <section>
    <p>
      Ihr könnt Euch nicht erinnern, wie Ihr hier gelandet seid. Im Getümmel der Arena könnt Ihr einige Gestalten ausmachen:
    </p>
    <div class="arena">
      {#each characters as character}
        <div class="character_card">
          <a href="/characters/{character.id}" class="character">
            <div class="name">{character.name}</div>
            <div class="text-sm">Level {character.level} {character.race}</div>
          </a>
          <a href="/fights/new?target_id={character.id}" class="btn attack" class:disabled={!canAttack(character)}>
            <div class="i-game-icons:sword-brandish w-1.7em h-1.7em"></div>
            <div>
              Angreifen
            </div>
          </a>
        </div>
      {/each}
      </div>
    </section>
  </main>
  
<style>
  .arena {
    display: flex;
    flex-direction: column;
    gap: 0.5em;
  }
  .attack {
    flex: 0;
  }
  .character_card {
    display: flex;
    border: 1px solid var(--color-border);
    border-radius: 1em;
    padding: 1em;
  }
  .character_card .character {
    flex: 1;
    text-decoration: none;
  }
  .disabled {
    opacity: 0.5;
    pointer-events: none;
  }
</style>