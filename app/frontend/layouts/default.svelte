<script>
  import "@unocss/reset/tailwind.css";

  import './default.css';
  import character from '~/lib/character.svelte';
  import { derived } from 'svelte/store';

  import { subscribe, reset as resetStores, reconnect } from 'livestores'
  import { NavStack, reset as resetNav, navstack, pushWithoutHistory } from "navstack";

  
  let {
    children,
    character_sgid,
    flash,
    panes = [],
  } = $props();

  // stores persist in SSR context, so we need to reset them
  resetStores();
  resetNav()

  
  let unsubscribe = null;
  let subscribedId = null;
  $effect(() => {
    if (subscribedId == character_sgid) return;
    reconnect();
    if (character_sgid) {
      subscribedId = character_sgid;
      unsubscribe = subscribe("CharacterChannel", { character_sgid });
    }
    else if (unsubscribe) {
      unsubscribe();
      unsubscribe = null;
      character.set(null);
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
            HP: {Math.ceil($character.hp)} / {$character.max_hp}
          </div>
        </div>
        {#if $character.hp <= 0}
          <span>Wiederbelebung in {Math.ceil($character.ressurection_in)}</span>
        {/if}
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
    </div>
  {:else if character_sgid}
    <div class="spinner"></div>
  {:else}
    <menu class="md:w-full px-4 py-2 ">
      <button class="btn primary" use:navstack={{
          group: "user",
          initialComponent: import("~/pages/characters/new.svelte"),
          initialPage: {url: "/characters/new"}
      }}>
        Charakter erstellen
      </button>
    </menu>
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
      <a href="/" use:navstack={{ replace: true }}>
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
    background: #e5e7eb;
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
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
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
    background: #cbcbcb;
    border-bottom-left-radius: 1em;
    border-bottom-right-radius: 1em;
    width: 100%;
  }
</style>