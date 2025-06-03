<script module>
  import { State } from 'activestate'

  State.toasts ||= [];

  export function showFlash(flash) {
    ['notice', 'error', 'success', 'info'].forEach(type => {
      if (flash[type]) {
        State.toasts.push({
          type,
          message: flash[type],
        });
      }
    });
  }
</script>
<script>
    import { fly, scale } from 'svelte/transition'
    import { flip } from 'svelte/animate'
    
    
    const toasts = $derived(State.toasts)
</script>

  <div class="toasts">
    {#each toasts as toast (toast.message)}
      <div class="toast {toast.type}" in:fly={{y:-40, duration: 400, opacity: 1}} out:scale animate:flip={{duration:300}}>
        {#if toast.title}
          <div class="title">
            {toast.title}
          </div>
        {/if}
        <div class="message grow">
          {toast.message}
        </div>
        <button class="close flex items-center" aria-label="close" onclick={() => State.toasts = toasts.filter(t => t != toast)}>
          <div class="i-material-symbols:close w-1.3em h-1.3em"></div>OK, cool     
        </button>
      </div>
    {/each}
  </div>
  
  <style>
    .toasts {
      position: fixed;
      top: 1em;
      gap: 1em;
      display: flex;
      right: 1em;
      flex-direction: column-reverse;
      z-index: 20;
      left: 1em;
      @media (min-width: 768px) {
        left: auto;
      }
    }
    .title {
      font-weight: bold;
      color: #333;
    }
    .toast {
      /* display: flex; */
      align-items: start;
      justify-content: space-between;
      gap: 1em;
      border: 1px solid #aaa;
      /* box-shadow: 0px 0px 0.8em 0px rgba(255, 192, 203, 0.7); */
      padding: 0.8em;
      padding-left: 1.2em;
      border-radius: 2em;
      background: white;
      box-shadow: 0px 0px 0.8em 0px rgba(0, 0, 0, 0.2);
      &.success {
        background: linear-gradient(#131, #010);
        border: 1px solid #161;
        color: #9f9;
      }
      &.error {
        background: linear-gradient(#511, #200);
        color: #f44;
        border: 1px solid #811;
      }
      &.info {
        color: #bbb;
        /* background: linear-gradient(#334, #303); */
        /* border: 1px solid #316; */
      }
    }
  </style>