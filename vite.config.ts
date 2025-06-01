import { sentryVitePlugin } from "@sentry/vite-plugin";
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import UnoCSS from 'unocss/vite'
import { svelte } from '@sveltejs/vite-plugin-svelte';
import path from 'path';
import env from 'vite-plugin-environment'


export default defineConfig(({mode}) => ({
  resolve: {
    alias: {
      livestores: path.resolve(__dirname, 'app/frontend/lib/livestores'),
      navstack: path.resolve(__dirname, 'app/frontend/lib/navstack'),
    }
  },

  server: {
    watch: {
      ignored: [
        '!**/node_modules/inertiax-svelte/**/*',
        '!**/node_modules/inertiax-core/**/*'
      ]
    }
  },

  plugins: [
    env({
      RAILS_ENV: 'development',
      SENTRY_DSN: null
    }), 
    RubyPlugin(),
    svelte({
      compilerOptions: {
        css: "injected"
      }
    }),
    UnoCSS(),
    sentryVitePlugin({
      org: "gladi",
      project: "gladi",
      telemetry: false,
      disable: mode !== 'production',
    })
  ],
  build: {
    sourcemap: true
  }
}))