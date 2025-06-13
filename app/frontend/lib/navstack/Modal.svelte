<script>
  import { fade } from "svelte/transition";
  import { cubicOut } from "svelte/easing";
  import NavStack from "./NavStack.svelte";

  const {
    close,
    ...rest
  } = $props();

  let stack

  export function push(options) {
    stack.push(options);
  }

  export function back() {
    if (stack.pop()) return
    close();
  }

  function variable(node, { delay = 0 }) {
    // duration on desktop is 300, on mobile 400
    const duration = window.innerWidth > 768 ? 300 : 400;
    return {
      delay,
      duration,
      easing: cubicOut,
      tick: (t) => {
        node.style.setProperty("--transition", t);
      },
      // css: (t) => `transform: scale(${t}); opacity: ${t};`
    };
  }
</script>

<div class="modal_container">
  <button aria-label="dismiss" class="modal_bg" transition:fade onclick={close}></button>
  <div class="modal" role="dialog" transition:variable>
    <NavStack bind:this={stack} {close} {...rest} />
  </div>
</div>

<style>
.modal_bg {
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
.modal_container {
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
.modal {
  position: absolute;
  bottom: 0;
  /* width: 100%; */
  overflow: hidden;
  transition: bottom 0.6s cubic-bezier(0.25, 1, 0.5, 1);
  bottom: calc(0 - var(--deltaTouchY, 0px));
  transform: translateY(calc((1 - var(--transition)) * 100%));
  height: 98%;
  /* overflow: hidden; */
  background-color: var(--color-bg);
}
@media (min-width: 600px) {
  .modal {
    transform: scale(var(--transition));
    opacity: var(--transition);
    width: 420px;
    height: calc(100% - 50px);
    max-height: 700px;
    bottom: auto !important;
    border-radius: 30px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
  }
  .modal_container {
      align-items: center;
      justify-content: center;
    }
}
</style>