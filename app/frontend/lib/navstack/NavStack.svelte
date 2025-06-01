<script module>
  import { history, shouldIntercept } from 'inertiax-core';

  const groups = $state({})

  export function navstack(node, options) {
    const group = options.group || Object.keys(groups).slice(-1)[0]
    node.addEventListener('click', (ev) => handleClick(ev, group, options))
    return {
      update: (newOptions) => {
        options = newOptions
      }
    }
  }

  function handleClick(ev, group, options = null) {
    if (!options && !ev.target.closest('[href]')) return;
    if (ev.target.closest('[data-navstack-ignore')) return;
    if (ev.target.closest('[data-method]')) return;
    if (ev.defaultPrevented) return;
    const href = ev.target.closest('[href]')?.getAttribute('href');
    if (href && !shouldIntercept(ev)) return;
    ev.preventDefault()
    options = {
      src: href,
      group,
      ...options
    }

    if (options.replace) {
      replace(options)
    } else {
      push(options)
    }
  }

  export function pushWithoutHistory(options) {
    const group = options.group || 'root';
    groups[group] ||= []
    groups[group].push({
      id: Math.random().toString(36),
      ...options
    })
  }

  export function push(options) {
    const group = options.group || 'root';
    history.pushExternal(group == "root" ? options.src : '', {
      arrive: () => {
        groups[group] ||= []
        groups[group].push({
          id: Math.random().toString(36),
          canBeClosedByBackNavigation: true,
          ...options
        })
      },
      recede: () => {
        if (groups[group]?.length == 1) return delete groups[group]
        groups[group]?.pop()
      }
    })
  }

  export function handleClose(group) {
    for (let i = groups[group].length - 1; i >= 0; i--) {
      const pane = groups[group][i]
      if (pane.canBeClosedByBackNavigation) {
        window.history.back()
      }
      else {
        groups[group].pop()
      }
    }
    delete groups[group]
  }

  export function handleBack(group) {
    const pane = groups[group]?.slice(-1)[0]
    if (pane.canBeClosedByBackNavigation) window.history.back()
    else {
      groups[group].pop()
      if (groups[group].length == 0) delete groups[group]
      if (group !== "root") return 
      const last = groups[group].slice(-1)[0]
      window.history.replaceState(window.history.state, '', last.src)
    }
  }

  export function replace(options) {
    const group = options.group || 'root';
    const oldGroup = groups[group]
    history.pushExternal(group == "root" ? options.src : '', {
      arrive: () => {
        groups[group] = [groups[group][0]]
        groups[group][0] = {
          ...groups[group][0],
          ...options
        }
      },
      recede: () => {
        groups[group] = oldGroup
      }
    })
  }

  export function reset() {
    for (const group in groups) {
      delete groups[group]
    }
  }

</script>

<script>
  import { fade, fly } from 'svelte/transition';
  import { sineOut, cubicOut } from 'svelte/easing'; 
  import { Frame } from 'inertiax-svelte';
  import { getContext } from 'svelte';

  const { page } = getContext('inertia')

  const { 
    children,
    snippet,
    component,
    panes = [],
    ...rest
  } = $props();

  groups.root = $state.snapshot(panes)
  groups.root.push({
    snippet: snippet || children,
    id: Math.random().toString(36),
    src: $page.url,
    component,
    ...rest
  })



  function variable(node, { delay = 0 }) {
    // duration on desktop is 300, on mobile 400
    const duration = window.innerWidth > 768 ? 300 : 400;
    return {
      delay,
      duration,
      easing: cubicOut,
      // tick: (t) => {
      //   node.style.setProperty("--transition", t);
      // },
      css: (t) => `--transition: ${t}`
    };
  }
</script>

{#snippet paneSnippet(group, i)}
  {@const pane = groups[group]?.[i]}
  {@const onclick = (ev) => handleClick(ev, group)}
  {@const back = () => handleBack(group)}
  {@const close = () => handleClose(group)}

  <div
  class="pane"
  role="presentation"
  {onclick}
  class:bottom={groups[group]?.length > i + 1}
  transition:fly|local={{ x: '100%', opacity: 1, duration: 300, easing: sineOut }}
  >
  {#if group !== "root" || i > 0}
    <nav>
      <button onclick={back}>
        {#if i == 0}
          <div class="i-uiw:close w-1.4em h-1.4em">
            Close
          </div>
        {:else} 
          <div class="i-uiw:arrow-left w-1.4em h-1.4em">
            Back
          </div>
        {/if}
      </button>
      {#if i > 0 && group !== "root"}
        <button onclick={close}>
          <div class="i-uiw:close w-1.4em h-1.4em">
            Close
          </div>
        </button>
      {/if}
    </nav>
  {/if}

  {#if pane.snippet}
    {@render pane.snippet({back, close})}
  {:else if pane.component}
    <pane.component {...pane} {back} {close}/>
  {:else} 
    {""} <!-- without this empty string, we get hydration mismatch. no clue why. -->
    <Frame {...pane} {onclick} {back} {close}/>
  {/if}
  </div>
{/snippet}



{#each Object.entries(groups) as [group, panes] (group)}
  <div class="group_container {group}">
    {#if group !== "root"}
      <div class="group_bg" transition:fade|global={{duration:200}}></div>
    {/if}
    <div class="group" transition:variable|global>
      {#each panes as pane, i (pane.id)}
        {@render paneSnippet(group, i)}
      {/each}
    </div>
  </div>
{/each}

<style>

.pane {
  position: absolute;
  inset: 0;
  width: 100%;
  transition: all 0.3s ease;
  opacity: 1;
  background: white;
  overflow-y: auto;
  overflow-x: hidden;
  display: grid;
  grid-template-areas:
    "header header header"
    "main main main"
    "footer footer footer";
  grid-template-columns: 1fr [inner-start] auto [inner-end] 1fr;
  grid-template-rows: auto 1fr auto;
  &.bottom {
    /* State for elements below the top one */
    opacity: 0;
    transform: scale(0.9);
    /* Prevent interaction with underlying elements */
    pointer-events: none;
  }
}

:global {
  .group header {
    grid-column: inner;
  }
  .root nav {
    border-bottom: 1px solid var(--color-border);
  }

}

nav {
  grid-area: header;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--padding);
}

.group_bg {
  background: linear-gradient(
    122deg,
    #f30075 0%,
    #b14bf4 100%
  /* #4d91ff 100% */
  );
  opacity: 0.6;
  filter: brightness(0.3);
  position: absolute;
  top: 0;
  right: 0;
  height: 100%;
  width: 100%;
  cursor: default;
}
.group_container {
  flex: 1 1 0%;
  align-items: flex-end;
  justify-content: center;
  display: flex;
  position: fixed;
  touch-action: pan-y;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 10;
}

.group_container .group {
  width: 100%;
  max-width: 100vw;
}
.group_container.root,
.group_container.root .group_bg {
  display: contents;
}
.group_container:not(.root) .group {
  position: absolute;
  bottom: 0;
  transition: bottom 0.6s cubic-bezier(0.25, 1, 0.5, 1);
  bottom: calc(0 - var(--deltaTouchY, 0px));
  transform: translateY(calc((1 - var(--transition)) * 100%));
  height: 98%;
  overflow: hidden;
  background-color: var(--color-bg);
  border-top-right-radius: 1rem;
  border-top-left-radius: 1rem;
}



@media (min-width: 768px) {
  .group_container:not(.root) .group {
    transform: scale(var(--transition));
    opacity: var(--transition);
    width: 420px;
    height: calc(100% - 50px);
    max-height: 700px;
    bottom: auto !important;
    border-radius: 30px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
  }
  .group_container {
    align-items: center;
    justify-content: center;
  }
}
</style>
