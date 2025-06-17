<script>
  import { augment } from "~/lib/character.svelte.js"
  import Time from "~/lib/time.svelte.js";
  import { State } from "activestate";
  import { navstack } from "navstack";

  const {
    characters
  } = $props();

  const augmentedCharacters = characters.map(augment)

  State.last_attacks ||= {}

  const lastAttacks = $derived(State.last_attacks);

  function canAttack(c) {
    let res = true
    if (Time.current_time() < lastAttacks[c.id] + 60) res = false
    if (c.id == State.character?.id) res = false
    if (c.hp <= 0) res = false
    return res
  }
</script>

<main>
  <section class="py-2">
    <h2 class="mb-2">Willkommen bei Arena Wars</h2>
    <p>
      Langsam betretet Ihr die Arena. Jubel und Geschrei ertönt von den Rängen. Als Ihr Euch umblickt, sehr Ihr viele merkwüdige Gestalten.
    </p>
    <div class="arena">
      {#each augmentedCharacters as character}
        <div class="character_card">
          <img
            class="portrait"
            src={character.portrait?.path}
            alt=""
          >
          <a href="/characters/{character.id}" class="character" use:navstack={{
            initialComponent: import("~/pages/characters/show.svelte"),
            character
            }}>
            <div class="name">{character.name}</div>
            <div class="text-sm">Level {character.level} {character.race}</div>
            <div class="text-sm">HP: {Math.ceil(character.hp())} / {character.max_hp()}</div>
 
          </a>
          <a href="/fights/new?target_id={character.id}" class="btn attack" class:disabled={!canAttack(character)}
          use:navstack={{
            initialComponent: import("~/pages/fights/new.svelte"),
            group: "arena",
            target: character
          }}
          >
            {#if Time.current_time() < lastAttacks[character.id] + 60}
              <div class="i-fluent:hourglass-24-regular w-1.7em h-1.7em"></div>
              Wartezeit&nbsp;{Math.round((lastAttacks[character.id] + 60 - Time.current_time()))}s
            {:else}
              <div class="i-game-icons:sword-brandish w-1.7em h-1.7em"></div>
              <div>
                Angreifen
              </div>
            {/if}
          </a>
        </div>
      {/each}
      </div>
    </section>
    <section>
      <p>
        Arena Wars ist eine <a href="https://github.com/buhrmi/arenawars">open-source</a> Neuinterpretation
        des Browsergames <strong>Gladiators 2</strong> von 2004.
      </p>
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
    transition: opacity 0.5s ease-in-out;
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