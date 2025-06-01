<script>
  import { useForm, inertia } from "inertiax-svelte";
  import Input from "~/components/Input.svelte";
  import Password from "~/components/Password.svelte";
  import { onDestroy, onMount } from "svelte";
  import { navstack } from "navstack";
  const { flash, close } = $props();

  let turnstileError = $derived(flash?.turnstile_error);

  let form = useForm({
    email: "", password: "",
    turnstile_token: ""
  });

  function submit(e) {
    e.preventDefault();
    $form.post(`/users`);
  }

  let captchaCompleted = $state(process.env.RAILS_ENV !== "production")
  let widgetId = null
  onMount(function() {
    if (captchaCompleted) return

    window.onloadTurnstileCallback = function() {
      widgetId = turnstile.render('#turnstile_container_signup', {
        theme: 'light',
        sitekey: '0x4AAAAAAAQHOuUYuYeDDJQ7',
        size: "flexible",
        callback: function(token) {
          $form.turnstile_token = token
          captchaCompleted = true
        }
      });
    }
    // load cloudflare turnstile js
    const script = document.getElementById('turnstile_script');
    if (script) window.onloadTurnstileCallback();
    else {
      const script = document.createElement('script');
      script.id = 'turnstile_script';
      script.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onloadTurnstileCallback'
      script.async = true;
      document.body.appendChild(script);
    }
  })

  onDestroy(function() {
    if (widgetId) {
      turnstile.remove(widgetId);
    }
  });

  function reloadCaptcha() {
    turnstile.reset(widgetId);
    turnstileError = null
  }
</script>

<main>
  <section>
    <h1 class="mb-4">
      Sign up
    </h1>
    <Input label="Email Address" bind:value={$form.email} bind:error={$form.errors['email']} />
    <Password label="Password" bind:value={$form.password}  bind:error={$form.errors['password']} />
    <div id="turnstile_container_signup"></div>
    {#if turnstileError}
    <div class="error">
      {turnstileError}
      <button onclick={reloadCaptcha}>
        Reload
        <div class="i-ci:arrow-reload-02 w-1.2em h-1.2em"></div>
      </button>
    </div>
    {/if}
    <p class="text-right">
      Already have an account? <a href="/session/new" use:navstack={{initialComponent: import("~/pages/sessions/new.svelte")}}>Sign in</a>
    </p>
  </section>
</main>

<footer>
  <section>
    <button class="btn primary" data-loader id="signup" onclick={submit} disabled={!captchaCompleted}>Sign up</button>
  </section>
</footer>