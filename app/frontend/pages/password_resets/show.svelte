<script>
  import { useForm } from 'inertiax-svelte';

  import Password from '~/components/Password.svelte';

  let {id} = $props()

  let form = useForm({password: ''})

  function submit(e) {
    e.preventDefault()
    $form.delete(`/password_resets/${id}`)
  }
</script>


<main>
  <section>
    <form onsubmit={submit}>
      <h1 class="text-1.5em mb-4">Set a new password</h1>
      
      <Password
        name="password"
        label="New password"
 
        bind:value={$form.password}
        required
        bind:error={$form.errors['password']}
      />
      <button class="btn primary" data-loader name="submit">Save password</button>
    </form>
  </section>
</main>
