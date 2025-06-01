import '@unocss/reset/tailwind.css'
import '~/layouts/default.css'
import "virtual:uno.css"

import resolve from '~/entrypoints/util/resolve'
import { createInertiaApp } from 'inertiax-svelte'
import createServer from 'inertiax-svelte/server'
import { render } from 'svelte/server'

createServer(page => {
  return createInertiaApp({
    page,
    resolve,
    setup({ App, props }) {
      return render(App, { props })
    }
  })
})