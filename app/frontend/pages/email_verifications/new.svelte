<script>
  import {getStore} from 'livestores';
  import {getContext} from 'svelte';

  const { close } = $props()

  const current_user = getStore("current_user");
  const { router } = getContext("inertia:_top")
  
  router.reload()
</script>

<main>
  <section>
    {#if $current_user?.email_verified}
      <h1>Email verified!</h1>
      <p>
        Thank you for verifying your email address. You can now close this window.
      </p>
      <button onclick={close} data-test="close-modal" class="btn primary">
        Close
        <!-- <div class="i-ep:right w-1.2em h-1.2em"></div> -->
      </button>
    {:else if $current_user?.email}
      <h1>
        Check your email
      </h1>
      <p>
        Before you can get started, you have to confirm your email address. Please check your {$current_user.email} inbox and click the link to activate your account.
      </p>
      <div class="text-center muted mb-4">
        Waiting...
      </div>
      <div class="spinner">
        
      </div>
    {/if}
  </section>
</main>

<style>
  .spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border-left-color: var(--color-brand); /* Or your preferred color */
    animation: spin 1s linear infinite;
    margin: 0 auto; /* Center the spinner */
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }
</style>