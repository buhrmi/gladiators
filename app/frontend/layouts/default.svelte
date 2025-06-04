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
  
  import { slide } from 'svelte/transition';
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
      State.character_id = null;
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

  let announcementClosed = $derived(State.announcementClosed || false);

  const character = $derived(State.character);
  
  // split character.coppers into gold, silver, and coppers, each 100 units
  const coppers = $derived((character?.coppers || 0) % 100);
  const silver = $derived(Math.floor((character?.coppers || 0) / 100) % 100);
  const gold = $derived(Math.floor((character?.coppers || 0) / 10000));
</script>

{#if !announcementClosed}
<div class="announcement relative text-balance" out:slide>
  <button class="close absolute top-2 right-2" onclick={() => State.announcementClosed = true}>
    <div class="i-uiw:close w-1.4em h-1.4em">Close</div>
  </button>
  Nach 20 Jahren mal wieder ein neues Gladi.<br>Hier geht's zum <a href="https://discord.gg/S4wb8V3GrP" target="_blank" rel="noopener noreferrer">Discord</a>. Kommt rein, bin einsam. Ne echt, is keine Sau da.
</div>
{/if}

<header class="md:flex-col h-full">
  {#if character}
    <div class="character">
      <div class="name">
        {character.name}<br>
      </div>
      <div class="details">
        Level {character.level} {character.race}
      </div>
      <div class="hp">
        <div class="hp-bar-container">
          <div
            class="hp-bar"
            style="width: {Math.max(0, Math.min(100, (character.hp() / character.max_hp()) * 100))}%"
          ></div>
          <div class="hp-text">
            HP: {Math.floor(character.hp())} / {character.max_hp()}
          </div>
        </div>
        {#if character.hp() <= 0}
          <span>Wiederbelebung in {Math.ceil(character.ressurection_in())}</span>
        {/if}
      </div>
      <div class="exp">
        <div class="exp-bar-container">
          <div
        class="exp-bar"
        style="width: {Math.max(0, Math.min(100, (character.exp_on_this_level() / character.exp_to_next_level()) * 100))}%"
          ></div>
          <div class="exp-text">
        EXP: {Math.floor(character.exp_on_this_level())} / {character.exp_to_next_level()}
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
  <NavStack {panes} {children} {loading} />
</main>

{#snippet loading()}
  <div class="w-full h-full items-center flex absolute">
    <div class="spinner"></div>
  </div>
{/snippet}

<style>
  /* Common styles for bar containers */
  .hp-bar-container,
  .exp-bar-container {
    width: 100%;
    height: 1.4em;
    border-radius: 0.6em;
    overflow: hidden;
    margin-bottom: 0.3em;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    position: relative;
  }

  /* Specific background for HP bar container */
  .hp-bar-container {
    background: #630505;
  }

  /* Specific background for EXP bar container */
  .exp-bar-container {
    background: #530272;
  }

  /* Common styles for the actual bars (fill) */
  .hp-bar,
  .exp-bar {
    height: 100%;
    transition: width 0.2s cubic-bezier(0.4,0,0.2,1);
  }

  /* Specific background for HP bar */
  .hp-bar {
    background: linear-gradient(#f87171 0%, #bd2605 100%);
  }

  /* Specific background for EXP bar */
  .exp-bar {
    background: linear-gradient(#a78bfa 0%, #6d28d9 100%);
  }

  /* Common styles for text overlay */
  .hp-text,
  .exp-text {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    color: white;
    font-size: 0.8em;
    text-shadow: 1px 1px 1px rgba(0,0,0,0.5);
    pointer-events: none;
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