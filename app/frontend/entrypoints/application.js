import { createInertiaApp } from 'inertiax-svelte'
import { Router } from 'inertiax-core';
import { hydrate, mount } from "svelte";
import resolve from "./util/resolve";
import Toast, {showFlash} from "~/components/Toasts.svelte";
import '~/components/loaders'
import { pushWithoutHistory } from "navstack"
import "virtual:uno.css"

createInertiaApp({
  resolve,
  setup({ el, App, props }) {
    hydrate(App, { target: el, props });
  },
});

// Delegate scrolling to the last pane
window.addEventListener('wheel', function(e) {
  if (e.target.closest("[scroll-region]")) return;
  e.preventDefault(); // Prevent default scrolling behavior
  const panes = document.querySelectorAll(".pane");
  const target = panes[panes.length - 1]; // Select the last pane
  if (!target) return;
  target.scrollTop += e.deltaY;
});

document.addEventListener("inertia:success", (event) => {
  const flash = event.detail.page.props.flash;
  if (!flash) return;
  showFlash(flash);
  if (flash.modal) {
    pushWithoutHistory({
      src: flash.modal,
      group: "modal"
    })
  }
})

mount(Toast, {
  target: document.body
})




window.addEventListener("message", (event) => {
  if (event.data === "logged_in") {
    Router.for("_top").reload();
  }
});
