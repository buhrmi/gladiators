<script>
  import { getStore } from 'livestores'
  import { navstack } from "navstack";
  const current_user = getStore("current_user")
</script>


<header>
  {$current_user?.email}
</header>

<main>
  <section>
    <menu>
      <li>
        <button use:navstack={{snippet: settings}}>Account Settings</button>
      </li>
      <li>
        <a href="/session" data-method="delete">Log out</a>  
      </li>
    </menu>
  </section>
</main>

{#snippet settings()}
  <main>
    <section>
      <h1 class="mb-4">Account Settings</h1>
      <menu>
        <li>
          <a href="/password_resets/new">Change Password</a>
        </li>
      </menu>
    </section>
  </main>
{/snippet}

<style>
  menu {
    grid-column: full;
    li {
      display: flex;
      border-top: 1px solid var(--color-border);
      &:last-child {
        border-bottom: 1px solid var(--color-border);
      }
    }
    li > * {
      width: 100%;
      padding: 1rem 1rem;
      display: flex;

    }
  }
</style>