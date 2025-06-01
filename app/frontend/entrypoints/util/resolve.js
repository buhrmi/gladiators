import layout from'~/layouts/default.svelte'
const pages = import.meta.glob('~/pages/**/*.svelte')

export default async name => {
  const componentPath = `/pages/${name}.svelte`

  if (!pages[componentPath]) throw new Error(`Unknown page ${componentPath}`)
  // if (!layouts[layoutPath]) throw new Error(`Unknown layout ${layoutPath}`)
  const page = await pages[componentPath]()
  // const layout = await layouts[layoutPath]()
  return Object.assign({
    layout
  }, page)
}