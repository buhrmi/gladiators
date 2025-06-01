import './loading.css'

let loaderElement = null
window.addEventListener("click", (event) => {
  loaderElement = event.target.closest("[data-loader]")
}, {capture: true})

window.addEventListener("submit", (event) => {
  loaderElement = event.target.closest("form")?.querySelector("[data-loader]");
}, {capture: true})

document.addEventListener("inertia:before", (event) => { 
  if (loaderElement) {
    loaderElement.classList.add("loading");
    loaderElement.setAttribute("aria-busy", "true");
    loaderElement.setAttribute("disabled", "true");
    const spinner = document.createElement("div");
    spinner.className = "spinner";
    loaderElement.appendChild(spinner);
  }
})

document.addEventListener("inertia:finish", (event) => {
  document.querySelectorAll("[data-loader].loading").forEach((el) => {
    el.classList.remove("loading");
    el.removeAttribute("aria-busy");
    el.removeAttribute("disabled");
    const spinner = el.querySelector(".spinner");
    if (spinner) {
      spinner.remove();
    }
  });
})