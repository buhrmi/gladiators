import { sentryVitePlugin } from "@sentry/vite-plugin";
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import UnoCSS from 'unocss/vite'
import { svelte } from '@sveltejs/vite-plugin-svelte';
import path from 'path';
import env from 'vite-plugin-environment'
import ruby2js from '@ruby2js/vite-plugin';

export default defineConfig(({mode}) => ({
  resolve: {
    alias: {
      activestate: path.resolve(__dirname, 'app/frontend/lib/activestate'),
      navstack: path.resolve(__dirname, 'app/frontend/lib/navstack'),
      $: __dirname + '/lib',
    },
    extensions: ['.rb', '.js.rb'].concat(
      ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json']
    )
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
    }),
    ruby2js({
      refresh: null,
      eslevel: 2021,
      autoexports: true,
      filters: ['return', 'functions', 'esm'],
      // include: 'class',
      underscored_private: false,
    })
  ],
  build: {
    sourcemap: true
  }
}))