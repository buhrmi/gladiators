<script>
  import character, { augment } from "~/lib/character.svelte.js"
  import { State } from "activestate";

  const {
    characters
  } = $props();

  State.last_attacks ||= {}
  const lastAttacks = $derived(State.last_attacks);

  function canAttack(c) {
    let res = true
    if (c.attack_forbidden(lastAttacks[c.id])) res = false
    if (c.id == $character?.id) res = false
    if (c.hp <= 0) res = false
    return res
  }
</script>

<main>
  <section class="py-2">
    <h2 class="mb-2">Ihr betretet die Arena</h2>
    <p>
      Ihr könnt Euch nicht erinnern, wie Ihr hier gelandet seid. Im Getümmel der Arena könnt Ihr einige Gestalten ausmachen:
    </p>
    <div class="arena">
      {#each characters as c}
        {@const character = augment(c)}
        <div class="character_card">
          <img
            class="portrait"
            src={character.portrait?.path}
            alt=""
          >
          <a href="/characters/{character.id}" class="character">
            <div class="name">{character.name}</div>
            <div class="text-sm">Level {character.level} {character.race}</div>
            <div class="text-sm">HP: {Math.ceil(character.hp)} / {character.max_hp}</div>
            <div class="text-sm">
              {#if character.attack_forbidden(lastAttacks[character.id])}
                Angriffssperre {Math.round(character.remaining_attack_forbidden(lastAttacks[character.id]))} Sekunden
              {/if}
            </div>
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
    height: 100%;
  }
  .character_card {
    display: flex;
    align-items: center;
    border: 1px solid var(--color-border);
    border-radius: 4em;
    padding: 0.5em;
  }
  .character_card .character {
    flex: 1;
    text-decoration: none;
  }
  .disabled {
    opacity: 0.5;
    pointer-events: none;
  }
  .portrait {
    width: 4em;
    height: 4em;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 1em;
    background: var(--color-border);
    border: 1px solid white;
  }
</style>