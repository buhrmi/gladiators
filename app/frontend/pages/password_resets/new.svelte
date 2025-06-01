<script>
  import { useForm } from 'inertiax-svelte'
  import { getStore } from '~/lib/livestores'
  import Input from '~/components/Input.svelte'
  
  const { email } = $props()

  const currentUser = getStore('current_user')

  let form = useForm({email})
  
  function autofocus(node) {
    node.focus({
      preventScroll: true
    })
  }
</script>

<main>
  <section>
  <h1 class="mb-4">
    Reset your password
  </h1>

  {#if $currentUser}
  <p class="mb-4">
    Click the button below to send a password reset email to <strong>{$currentUser.email}</strong>.
  </p>
  <form on:submit|preventDefault={() => $form.post(`/password_resets`)} class="">
    
    <button class="btn primary" name="login" data-loader>Send link</button>
    
  </form>
  {:else}
    <p class="mb-4">
      Please enter your email address and we will send you a link to reset your password.
    </p>

    <form on:submit|preventDefault={() => $form.post(`/password_resets`)} class="">
      <Input 
        name="email"
        label="Email"
        bind:value={$form.email}
        required
        bind:error={$form.errors['email']}
        
      />
      
      <button class="btn primary" name="login" data-loader>Send email</button>
      
    </form>
  {/if}
  </section>
</main>