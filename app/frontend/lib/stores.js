import { getStore, registerHandler } from "livestores"
import { derived } from "svelte/store"
import deepmerge from "deepmerge"

// target and source are two arrays containing [timestamp, value] tuples.
// returns a new array with both arrays merged and sorted
function combineTimestampedArrays(target, source) {
  const combined = target.concat(source);
  combined.sort((a, b) => a[0] - b[0]);
  return combined.reduce((acc, curr) => {
    if (acc.length === 0 || acc[acc.length - 1][0] !== curr[0]) {
      acc.push(curr);
    }
    return acc;
  }, []);
}

// uses the combineTimestampedArrays function to merge price data
registerHandler("mergePrices", (store, data) => {
  store.update(current => deepmerge(current, data, combineTimestampedArrays))
});

// prices is a store containing timestamped prices for all symbols
// eg. { "BTC": [[timestamp, price], ...], "ETH": [[timestamp, price], ...] }
const prices = getStore("prices", {})

export const lastPrices = derived(prices, ($prices) => {
  const lastPrices = {}
  for (const [key, value] of Object.entries($prices)) {
    lastPrices[key] = value[value.length - 1][1]
  }
  return lastPrices
})

