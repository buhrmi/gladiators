<script>
  import Input from "~/components/Input.svelte";

  let { value = $bindable(), error, ...props } = $props();

  import { slide } from 'svelte/transition'

  let showPasswordHints = $state(false)
  
  let checkPassword = $state(false)
  let has7chars = $derived(value?.length >= 7)
  let hasUppercase = $derived(value && /[A-Z]/.test(value))
  let hasLowercase = $derived(value && /[a-z]/.test(value))
  let hasNumber = $derived(value && /[0-9]/.test(value))
  let errorHas7chars = $derived(checkPassword && !has7chars)
  let errorHasUppercase = $derived(checkPassword && !hasUppercase)
  let errorHasLowercase = $derived(checkPassword && !hasLowercase)
  let errorHasNumber = $derived(checkPassword && !hasNumber)

  function onPwChanged() {
    error = null
    checkPassword = false
    showPasswordHints = true
    if (has7chars && hasUppercase && hasLowercase && hasNumber) {
      showPasswordHints = false
    }
  }
</script>


<Input type="password" bind:value bind:error oninput={onPwChanged} onblur={() => checkPassword = value} onfocus={onPwChanged} {...props} />

{#if showPasswordHints}
  <div class="hints" transition:slide>
    Your password must contain at least:<br>
    <ul>
      <li class:error={errorHas7chars} class:success={has7chars}>7 characters</li>
      <li class:error={errorHasUppercase} class:success={hasUppercase}>1 uppercase letter</li>
      <li class:error={errorHasLowercase} class:success={hasLowercase}>1 lowercase letter</li>
      <li class:error={errorHasNumber} class:success={hasNumber}>1 number</li>
    </ul>
  </div>
{/if}

<style>
  .hints {
    font-size: 0.8em;
    margin-top: -1em;
    margin-bottom: 1em;
  }
  .hints ul {
    color: #818181;
  }
  .hints ul {
    list-style: none;
    padding-left: 0.5rem;
  }
  .hints ul li::before{
    /* this adds a circle */
    content: '• ';
    display: inline-block;
    width: 1.4em;
  }
  .error {
    color: rgb(193, 72, 72);
  }
  .hints ul li.error::before {
    content: '✗ ';
  }
  .success {
    color: rgb(80, 172, 80);
  }
  .hints ul li.success::before {
    content: '✓ ';
  }
</style>