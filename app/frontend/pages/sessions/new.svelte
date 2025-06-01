<script>
  import { useForm, inertia } from "inertiax-svelte";
  import Input from "~/lib/ui/Input.svelte";
  import { onDestroy, onMount } from "svelte";
  import { navstack } from "navstack";

  const { flash } = $props();

  let turnstileError = $derived(flash?.turnstile_error);

  let form = useForm({
    email: "", 
    password: "",
    turnstile_token: ""
  });

  function submit(e) {
    e.preventDefault();
    $form.post(`/session`);
  }

  let captchaCompleted = $state(process.env.RAILS_ENV !== "production")
  let widgetId = null
  onMount(function() {
    return // TODO: require turnstile after second or thrid try
    window.onloadTurnstileCallback = function() {
      widgetId = turnstile.render('#turnstile_container_signin', {
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
      Welcome back
    </h1>
    <Input name="email" label="Email Address" bind:value={$form.email} bind:error={$form.errors['email']} />
    <Input name="password" type="password" label="Password" bind:value={$form.password}  bind:error={$form.errors['password']} />
    {#if flash?.error}
      <div class="error">
        {flash.error}
      </div>
    {/if}
    <p class="text-right">
      <a href="/password_resets/new" use:navstack={{
        initialComponent: import("~/pages/password_resets/new.svelte"),
        email: $form.email
      }}>Forgot password?</a>
    </p>

    <!-- <div id="turnstile_container_signin"></div> -->
    {#if turnstileError}
      <div class="error">
        {turnstileError}
        <button onclick={reloadCaptcha}>
          Reload
          <div class="i-ci:arrow-reload-02 w-1.2em h-1.2em"></div>
        </button>
      </div>
    {/if}
  </section>
</main>

<footer>
  <section>
    <button class="btn primary" data-loader id="login" onclick={submit}>Sign in</button>
  </section>
</footer>