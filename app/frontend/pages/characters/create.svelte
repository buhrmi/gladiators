<script>
  import { getContext } from 'svelte';
  const { 
    close, 
    return_to
  } = $props();
  
  const { router: topRouter } = getContext('inertia:_top');
  const { router } = getContext('inertia');
  
  if (return_to) {
    router.visit(return_to);
  } else {
    close()
  }
  topRouter.reload()
</script>