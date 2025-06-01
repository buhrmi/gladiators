<script>
  import { getContext } from 'svelte';
  const { close } = $props();
  const { router } = getContext('inertia:_top');

  router.reload()
</script>