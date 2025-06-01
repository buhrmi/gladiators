<script module>
    import { fly, scale } from 'svelte/transition'
    import { flip } from 'svelte/animate'

    const flashKeys = ['notice', 'success', 'error']

    let toasts = $state([
    // {
    //   type: 'success',
    //   message: 'You have been logged in!',
    //   id: 132
    // },
    // {
    //   type: 'info',
    //   message: 'You have been logged in!',
    //   id: 34
    // },{
    //   type: 'error',
    //   message: 'You have been logged in!',
    //   id: 342
    // },
    ])
  
    // calls showToast for each entry in the flash object
    export function showFlash(flash) {
      if (flash) {
        for (const key of flashKeys) {
          if (flash[key]) {
            showToast({ type: key, message: flash[key] })
          }
        }
      }
    }

    export function showToast(toast) {
      toast = {
        ...toast,
        id: Math.random()
      }
      toasts.push(toast);
      setTimeout(() => {toasts = toasts.filter(t => t.id != toast.id)}, 4200);
    }
  
    function createToast(type) {
      return (toast) => showToast({ type, ...toast });
    }
  
    export const toast = {
      show: showToast,
      ...Object.fromEntries(
        flashKeys.map(type => [
          type,
          createToast(type)
        ]
      ))
    }


  </script>
  
  <div class="toasts">
    {#each toasts as toast (toast.id)}
      <div class="toast {toast.type}" in:fly={{y:-20}} out:scale animate:flip={{duration:300}}>
        <div class="message grow text-center">
          {toast.message}
        </div>
        <button class="close" aria-label="close" onclick={() => toasts = toasts.filter(t => t != toast)}>
          <div class="i-iwwa:close w-1.1em h-1.1em"></div>          
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
    .toast {
      display: flex;
      align-items: start;
      justify-content: space-between;
      gap: 1em;
      background: linear-gradient(#222, #111);
      border: 1px solid #444;
      /* box-shadow: 0px 0px 0.8em 0px rgba(255, 192, 203, 0.7); */
      padding: 0.8em;
      padding-left: 1.2em;
      border-radius: 1em;
      color: white;
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