<script>
  const { close, logged_in } = $props();
  import { push } from "navstack"


  function signin() {
    close();
    push({
      src: "/session/new",
      group: "signin",
    })
  }
</script>

<main>
  <section>
    <h1>Password changed</h1>
    <p>Your new password has been saved.</p>
    {#if logged_in}
      <button class="btn mt-4 primary" id="close" onclick={close}>Close</button>
    {:else}
      <button class="btn mt-4 primary" id="sign_in" onclick={signin}>Sign in</button>
    {/if}
  </section>
</main>
