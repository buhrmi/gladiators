<script>
  import "@unocss/reset/tailwind.css";
  import './default.css';

  import { subscribe, reset as resetStores, getStore, reconnect } from 'livestores'
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
  
  const character = getStore("character")

  let unsubscribe = null;
  $effect(() => {
    reconnect();
    if (character_sgid) {
      unsubscribe = subscribe("CharacterChannel", {character_sgid});
    }
    else if (unsubscribe) {
      unsubscribe();
      unsubscribe = null;
      character.set(null);
    }
  })

  if (flash.modal) {
    pushWithoutHistory({
      src: flash.modal,
      group: "modal"
    })
  }


  subscribe('GlobalChannel', { subject: 'game' })
</script>

<header class="px-4 py-2 md:flex-col h-full">
  <menu class="md:w-full">
    {#if character_sgid}
      {#if $character}
        {$character.name}
      {:else}
      <div class="spinner"></div>
      {/if}
    {:else}
    <button class="btn primary" use:navstack={{
        group: "user",
        initialComponent: import("~/pages/characters/new.svelte"),
        initialPage: {url: "/characters/new"}
    }}>
      Charakter erstellen
    </button>
    {/if}
    <!-- {#if $current_user}
      <button id="user" use:navstack={{
        group: "user",
        initialComponent: import("~/pages/users/show.svelte"),
      }}>
        <img
          src={$current_user.profile_image.path}
          alt="profile"
          class="h-10 w-10 rounded-full"
        />
      </button>
    {:else if !logged_in}
      <button class="btn primary" use:navstack={{
        src: "/users/new",
        group: "signup",
        initialComponent: import("~/pages/users/new.svelte"),
      }}>
        Sign up
      </button>
    {/if} -->
  </menu>
</header>

<nav class="px-4 py-2 md:flex-col h-full">
  <menu class="w-full">
    <li>
      <a href="/">
        <div class="i-mdi:arena-outline w-1.8em h-1.8em"></div>
        <div>
          Arena
        </div>
      </a>
    </li>
  </menu>
</nav>

<main id="main">
  <NavStack {panes}>
    {@render children?.()}
  </NavStack>
</main>

<style>
  nav a {
    display: flex;
    flex-direction: column;
    align-items: center;
    /* padding: 0.5rem; */
    font-size: 0.875rem;
  }
  @media (min-width: 768px) {
    nav a {
      flex-direction: row;
      gap: 0.5rem;
      font-size: 1em;
      /* border: 1px solid #ccc; */
      border-radius: 3rem;
    }
    nav a:hover {
      background: #f0f0f0;
    }
  }
</style>