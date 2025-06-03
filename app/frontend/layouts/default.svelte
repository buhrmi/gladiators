<script module>
  export function login() {
    let url = "/session/new?provider=discord"
    let height = 850
    let width = 600
    var left = ( screen.width - width ) / 2
    var top = ( screen.height - height ) / 2
    window.open( url, "Log in to Gladiators Reloaded", 'resizable=1,scrollbars=no,width=' + width + ', height=' + height + ', top='+ top + ', left=' + left)
  }

  subscribe("ArenaChannel")
</script>

<script>
  import "@unocss/reset/tailwind.css";

  import './default.css';

  import character from '~/lib/character.svelte';
  import { derived } from 'svelte/store';

  import { subscribe, State } from 'activestate'
  import { NavStack, navstack, pushWithoutHistory } from "navstack";
  
  let {
    children,
    character_sgid,
    flash,
    panes = [],
  } = $props();

  
  let unsubscribe = null;
  let subscribedId = null;
  $effect(() => {
    if (subscribedId == character_sgid) return;
    if (unsubscribe) {
      unsubscribe();
      unsubscribe = subscribedId = null;
      State.character = null;
    }
    if (character_sgid) {
      subscribedId = character_sgid;
      unsubscribe = subscribe("CharacterChannel", { character_sgid });
    }
  });

  if (flash.modal) {
    pushWithoutHistory({
      src: flash.modal,
      group: "modal"
    })
  }

  // split $character.coppers into gold, silver, and coppers, each 100 units
  const coppers = $derived(($character?.coppers || 0) % 100);
  const silver = $derived(Math.floor(($character?.coppers || 0) / 100) % 100);
  const gold = $derived(Math.floor(($character?.coppers || 0) / 10000));

</script>

<header class="md:flex-col h-full">
  {#if $character}
    <div class="character">
      <div class="name">
        {$character.name}<br>
      </div>
      <div class="details">
        Level {$character.level} {$character.race}
      </div>
      <div class="hp">
        <div class="hp-bar-container">
          <div
            class="hp-bar"
            style="width: {Math.max(0, Math.min(100, ($character.hp / $character.max_hp) * 100))}%"
          ></div>
          <div class="hp-text">
            HP: {Math.floor($character.hp)} / {$character.max_hp}
          </div>
        </div>
        {#if $character.hp <= 0}
          <span>Wiederbelebung in {Math.ceil($character.ressurection_in)}</span>
        {/if}
      </div>
      <div class="exp">
        <div class="exp-bar-container">
          <div
        class="exp-bar"
        style="width: {Math.max(0, Math.min(100, ($character.exp_on_this_level / $character.exp_to_next_level) * 100))}%"
          ></div>
          <div class="exp-text">
        EXP: {Math.floor($character.exp_on_this_level)} / {$character.exp_to_next_level}
          </div>
        </div>
      </div>
      <div class="flex gap-1 items-center">
        {#if gold}
          {gold} <img src="/icons/gold.png" class="h-4" alt="Gold" />
        {/if}
        {#if silver}
          {silver} <img src="/icons/silver.png" class="h-4" alt="Silver" />
        {/if}
        {coppers} <img src="/icons/copper.png" class="h-4" alt="Kupfer" />
      </div>
      <a href="/session" data-method="delete">Log out</a>
    </div>
  {:else if character_sgid}
    <div class="spinner"></div>
  {:else}
    <div class="character text-center flex items-center gap-2 md:flex-col">
      <button class="btn primary" use:navstack={{
        src: "/characters/new",
        group: "user",
        initialComponent: import("~/pages/characters/new.svelte"),
      }}>
        Char erstellen
      </button>
      <div class="whitespace-nowrap">
        oder 
        <button onclick={login}>
          einloggen
        </button>
      </div>
    </div>
  {/if}
</header>

<nav class="px-4 py-2 ">
  <menu class="w-full flex justify-around items-center gap-2 md:gap-4 md:block">
    <li>
      <a href="/" use:navstack={{ replace: true }}>
        <div class="i-mdi:arena w-1.8em h-1.8em"></div>
        <div>
          Arena
        </div>
      </a>
    </li>
        <li>
      <a href="/guild" use:navstack={{ replace: true }}>
        <div class="i-game-icons:barracks-tent w-1.8em h-1.8em"></div>
        <div>
          Gilde
        </div>
      </a>
    </li>
  </menu>
</nav>

<main id="main">
  <NavStack {panes} {children} />
</main>

<style>
  .hp-bar-container {
    width: 100%;
    height: 1.2em;
    background: #630505;
    border-radius: 0.6em;
    overflow: hidden;
    margin-bottom: 0.3em;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    position: relative; /* Added for positioning context */
  }
  .hp-bar {
    height: 100%;
    background: linear-gradient(#f87171 0%, #bd2605 100%);
    transition: width 0.2s cubic-bezier(0.4,0,0.2,1);
  }
  .hp-text { /* New style for the HP text */
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    text-align: center;
    color: white; /* Or any color that contrasts well with your bar */
    font-size: 0.8em; /* Adjust as needed */
    text-shadow: 1px 1px 1px rgba(0,0,0,0.5); /* Optional: for better readability */
    pointer-events: none; /* To allow clicks to pass through to the bar if needed */
  }
  .exp-bar-container {
    width: 100%;
    height: 1.2em;
    background: #530272;
    border-radius: 0.6em;
    overflow: hidden;
    margin-bottom: 0.3em;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    position: relative; /* Added for positioning context */
  }
  .exp-bar {
    height: 100%;
    background: linear-gradient(#a78bfa 0%, #6d28d9 100%);
    transition: width 0.2s cubic-bezier(0.4,0,0.2,1);
  }
  .exp-text { /* New style for the EXP text */
    position: absolute;
    top: 0;
    left: 0;
    width: 100%; /* Ensure it covers the entire bar */
    text-align: center; /* Center the text */
    color: white; /* Or any color that contrasts well with your bar */
    font-size: 0.8em; /* Adjust as needed */
    text-shadow: 1px 1px 1px rgba(0,0,0,0.5); /* Optional: for better readability */
    pointer-events: none; /* To allow clicks to pass through to the bar if needed */
  }

  nav a {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 0.875rem;
  }
  @media (min-width: 768px) {
    nav a {
      flex-direction: row;
      gap: 0.5rem;
      font-size: 1em;
      padding: 0.5rem 1rem;
      border-radius: 3rem;
    }
    nav a:hover {
      background: #f0f0f0;
    }
  }
  .character {
    padding: 0.5rem 1rem;
    /* background: #cbcbcb; */
    border-bottom: 1px solid var(--color-border);
    width: 100%;
  }
</style>