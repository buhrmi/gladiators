import { presetIcons, presetUno } from "unocss";
import extractorSvelte from "@unocss/extractor-svelte";
import { defineConfig } from 'unocss'
import { presetWind } from "unocss/preset-wind3";

export default defineConfig({
  // ...UnoCSS options
  extractors: [extractorSvelte()],
  
  presets: [
    presetWind(),
    presetIcons({
      // cdn: 'https://esm.sh/',
      extraProperties: {
        display: "inline-block",
        "vertical-align": "middle",
      },
    }),
  ],
})
