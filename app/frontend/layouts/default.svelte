<script module>
  export function login() {
    let url = "/session/new?provider=discord"
    let height = 850
    let width = 600
    var left = ( screen.width - width ) / 2
    var top = ( screen.height - height ) / 2
    window.open( url, "Arenakampf", 'resizable=1,scrollbars=no,width=' + width + ', height=' + height + ', top='+ top + ', left=' + left)
  }

  subscribe("ArenaChannel")
</script>

<script>
  import "@unocss/reset/tailwind.css";
  import './default.css';
  
  import { slide } from 'svelte/transition';
  import { derived } from 'svelte/store';

  import { subscribe, State } from 'activestate'
  import { NavStack, navstack } from "navstack";
  
  let {
    children,
    character_sgid,
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
      State.last_attacks = {};
    }
    if (character_sgid) {
      subscribedId = character_sgid;
      unsubscribe = subscribe("CharacterChannel", { character_sgid });
    }
  });

  let announcementClosed = $derived(State.announcementClosed || false);

  const character = $derived(State.character);
  
  // split character.coppers into gold, silver, and coppers, each 100 units
  const coppers = $derived((character?.coppers || 0) % 100);
  const silver = $derived(Math.floor((character?.coppers || 0) / 100) % 100);
  const gold = $derived(Math.floor((character?.coppers || 0) / 10000));
</script>

{#if !announcementClosed}
<div class="announcement relative text-balance px-8" out:slide>
  <button class="close absolute top-2 right-2" onclick={() => State.announcementClosed = true}>
    <div class="i-uiw:close w-1.4em h-1.4em">Close</div>
  </button>
  Dies ist ein Testserver. Datenbank wird immer mal wieder zurückgesetzt.
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
            HP: {Math.ceil(character.hp())} / {character.max_hp()}
          </div>
        </div>
        {#if character.hp() <= 0}
          <span>Wiederbelebung in {Math.ceil(character.resurrection_in())}s</span>
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
        <button
          onclick={login}
          class="flex items-center bg-white border border-gray-300 rounded-lg shadow-md px-6 py-2 text-sm font-medium text-gray-800 hover:bg-gray-200"
        >
          <svg
            class="h-6 w-6 mr-2"
            xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            width="800px"
            height="800px"
            viewBox="0 -28.5 256 256"
            version="1.1"
            preserveAspectRatio="xMidYMid"
          >
            <g>
              <path
                d="M216.856339,16.5966031 C200.285002,8.84328665 182.566144,3.2084988 164.041564,0 C161.766523,4.11318106 159.108624,9.64549908 157.276099,14.0464379 C137.583995,11.0849896 118.072967,11.0849896 98.7430163,14.0464379 C96.9108417,9.64549908 94.1925838,4.11318106 91.8971895,0 C73.3526068,3.2084988 55.6133949,8.86399117 39.0420583,16.6376612 C5.61752293,67.146514 -3.4433191,116.400813 1.08711069,164.955721 C23.2560196,181.510915 44.7403634,191.567697 65.8621325,198.148576 C71.0772151,190.971126 75.7283628,183.341335 79.7352139,175.300261 C72.104019,172.400575 64.7949724,168.822202 57.8887866,164.667963 C59.7209612,163.310589 61.5131304,161.891452 63.2445898,160.431257 C105.36741,180.133187 151.134928,180.133187 192.754523,160.431257 C194.506336,161.891452 196.298154,163.310589 198.110326,164.667963 C191.183787,168.842556 183.854737,172.420929 176.223542,175.320965 C180.230393,183.341335 184.861538,190.991831 190.096624,198.16893 C211.238746,191.588051 232.743023,181.531619 254.911949,164.955721 C260.227747,108.668201 245.831087,59.8662432 216.856339,16.5966031 Z M85.4738752,135.09489 C72.8290281,135.09489 62.4592217,123.290155 62.4592217,108.914901 C62.4592217,94.5396472 72.607595,82.7145587 85.4738752,82.7145587 C98.3405064,82.7145587 108.709962,94.5189427 108.488529,108.914901 C108.508531,123.290155 98.3405064,135.09489 85.4738752,135.09489 Z M170.525237,135.09489 C157.88039,135.09489 147.510584,123.290155 147.510584,108.914901 C147.510584,94.5396472 157.658606,82.7145587 170.525237,82.7145587 C183.391518,82.7145587 193.761324,94.5189427 193.539891,108.914901 C193.539891,123.290155 183.391518,135.09489 170.525237,135.09489 Z"
                fill="#5865F2"
                fill-rule="nonzero"
              >
              </path>
            </g>
          </svg>
          <span>Einloggen</span>
        </button>
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
      <a href="/auctions" use:navstack={{ replace: true }}>
        <!-- <div class="i-game-icons:barracks-tent w-1.8em h-1.8em"></div> -->
        <div class="i-tdesign:shop-2-filled w-1.8em h-1.8em"></div>
        <div>
          Marktplatz
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