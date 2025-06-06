import '@unocss/reset/tailwind.css'
import '~/layouts/default.css'
import "virtual:uno.css"

import resolve from '~/entrypoints/util/resolve'
import { createInertiaApp } from 'inertiax-svelte'
import createServer from 'inertiax-svelte/server'
import { render } from 'svelte/server'
import { reset } from 'activestate'

createServer(page => {
  // state persist in SSR context, so we need to reset them
  reset();
  return createInertiaApp({
    page,
    resolve,
    setup({ App, props }) {
      return render(App, { props })
    }
  })
})