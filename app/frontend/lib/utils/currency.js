import { getContext } from "svelte"


export function format(amount, currency) {
  currency = getContext("current_currency")

  if (amount === null) return 'N/A'
  
  const formatted = new Intl.NumberFormat('en-US', {
    minimumFractionDigits: 0,
    maximumFractionDigits: currency?.decimals || 2,
  }).format(amount)
  
  if (currency.postfix) return `${formatted} ${currency.postfix.toUpperCase()}`
  else return formatted
}