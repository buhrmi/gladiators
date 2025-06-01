# Inertia X NavStack: Simplified Navigation

Inertia X NavStack helps you manage complex navigation flows in your [Inertia X](https://github.com/buhrmi/inertiax) applications, especially for features like multi-step wizards, master-detail views, or modal dialogs that need their own navigation history.

<video src="https://github.com/user-attachments/assets/48f900c3-a5c2-4610-8093-03de954ed134"></video>

## Core Idea: Groups and Panes

Imagine your application's navigation as a series of layers or stacks:

1.  **NavStack:** The main container managing all these layers.
2.  **Groups:** Within the NavStack, you have "groups" of related views.
    *   There's a primary `root` group for your main application flow.
    *   Any new group you create automatically behaves like a **modal** dialog, appearing on top of the current view.
3.  **Panes:** Each group consists of one or more "panes." A pane is essentially a single view or screen.
    *   When you navigate within a group, new panes are typically added, allowing users to go "back" to the previous pane in that same group.
    *   The first pane in a group doesn't show a "back" button.
    *   If a group is a modal, its panes will also show a "close" button to dismiss the entire group.

By default, clicking a link within a pane will automatically push a new pane onto the current group, using the link's `href` as the source for the new pane's content.

## Getting Started: Basic Usage

Here's how to set up a basic NavStack in your Svelte layout:

```svelte
// layout.svelte
<script>
  import { NavStack, navstack } from 'inertiax-navstack';
  // The `props()` function is specific to Inertia X's way of handling layouts
  const { children } = props(); 
</script>

<nav>
  {#if someConditionToShowSignUpLink}
    <a href="/users/new" use:navstack={{ group: "signup" }}> 
      Sign up (opens in a new 'signup' modal group)
    </a>
  {/if}
  <a href="/dashboard" use:navstack>
    Dashboard (navigates within the current group)
  </a>
</nav>

<NavStack>  
  {@render children()} {/* This renders your current Inertia page as the first pane */}
</NavStack>
```

**What's happening here?**

*   `<NavStack>`: This component is the heart of the system. It will render your navigation panes.
*   `{@render children()}`: In an Inertia X layout, `children()` renders the current page component. This page becomes the **initial pane** in a default group called `root`.
*   `use:navstack`: This Svelte action is attached to links.
    *   On the "Dashboard" link, it will push a new pane (loading `/dashboard`) onto the current group.
    *   On the "Sign up" link, `group: "signup"` tells NavStack to create a *new group* named "signup" (which will appear as a modal) and load `/users/new` as its first pane.

## The `<NavStack>` Component

This component is the main container for all your navigation groups and panes.

### `children` (Default Slot Content)

The content you place directly inside `<NavStack>...</NavStack>` (typically `{@render children()}` in an Inertia X layout) is used to create the **first pane of the `root` group**.

### Props

*   **`rootPanes`**: `Array` (Optional)
    An array of pane definitions to initialize the `root` group with *before* adding the main child content pane. This is extremely useful for handling "deep links." If a user lands directly on a page like `/settings/profile`, you might want them to be able to navigate "back" to `/settings` and then to `/` (homepage).

    **Example: Handling Deep Links**
    ```svelte
    // layout.svelte
    <script>
      import { NavStack } from 'inertiax-navstack';
      import { getContext } from 'svelte';
      import { page } from '@inertiajs/svelte'; // Correct import for Inertia's page store

      const { children } = props();
      
      let initialRootPanes = [];
      
      // If the user isn't on the homepage, add the homepage as a pane 
      // so they can navigate "back" to it.
      if ($page.url !== "/") {
        initialRootPanes.push({ src: "/" }); // Pane definition: load content from "/"
      }
      // You could add more panes here if needed, e.g., a section index page
      // if ($page.url.startsWith("/settings/") && $page.url !== "/settings") {
      //   initialRootPanes.push({ src: "/settings" });
      // }
    </script>

    <NavStack rootPanes={initialRootPanes}>
      {@render children()} {/* The current page is added on top of rootPanes */}
    </NavStack>
    ```
    In this example, if the user lands on `/some/deep/page`, the `root` group will effectively have `[{src: "/"}, {src: "/some/deep/page"}]`, allowing them to go back to the homepage.

## The `navstack` Action

This Svelte action is attached to an HTML element (usually an `<a>` tag) to control how clicks on that element affect the NavStack.

```svelte
<a href="/users/new" use:navstack={options}>Create User</a>
```

By default (with no options), it pushes a new pane onto the *current* group, using the element's `href` attribute to load the content.

### Options

*   **`group`**: `string` (Optional)
    The name of the group to modify. If provided, actions will target this specific group. If the group doesn't exist, it will be created (and will appear as a modal).
    ```svelte
    <a href="/auth/login" use:navstack={{ group: "authModal" }}>Login</a> 
    ```
*   **`replace`**: `boolean` (Default: `false`)
    If `true`, instead of pushing a new pane, the **entire specified group** (or the current group if `group` is not set) will be replaced with a single new pane (loaded from the `href`).
    ```svelte
    <a href="/dashboard" use:navstack={{ replace: true }}>Go to Dashboard (replaces current group)</a>
    ```
*   **`snippet`**: `Snippet` (Optional)
    The snippet to render inside of the pane. If set, no Inertia X Frame will be rendered, and no request will be made.
*   **`component`**: `Component` (Optional)
    The component to render inside of the pane. If set, no Inertia X Frame will be rendered, and no request will be made.
*   **Other Options:**
    Any other options you provide (e.g., `initialComponent`, props for `initialComponent`) will be passed directly to the underlying snippet, component, or [Inertia X `<Frame>` component](https://github.com/buhrmi/inertiax) that NavStack uses to render panes.

## Programmatic Navigation

Sometimes, you need to control navigation from your JavaScript logic (e.g., after a form submission) instead of just link clicks.

The component or snippet rendered inside each pane automatically receives `push`, `replace`, `recede`, and `close` functions as props.

```svelte
<script>
  // Inside a Svelte component rendered as a pane
  const { push, replace, recede, close, /* other props */ } = $props();

  function handleSuccess() {
    // After success, go back one pane in the current group
    recede(); 
  }

  function goToProfile() {
    // Push a new pane onto the current group
    push({ src: "/profile" }); 
  }

  function startOver() {
    // Replace the entire current group with the /home pane
    replace({ src: "/home" });
  }

  function closeModal() {
    // Close the current group (if it's a modal)
    close();
  }
</script>

<button on:click={closeModal}>Close This Modal</button>
```

You can also import these functions directly if you need to trigger navigation from outside a pane (e.g., from a global menu or after some background task completed):

```javascript
import { push, replace, recede, close } from 'inertiax-navstack';

// Push a new pane into the 'settings' group
push('settings', { src: "/settings/notifications" });

// Replace the entire 'checkout' group with a success page
replace('checkout', { src: "/checkout/success" });

// Go back one pane in the 'wizard' group
recede('wizard');

// Close the 'helpModal' group
close('helpModal');
```

### Navigation Functions:

*   **`push(options)`** (as prop) or **`push(groupName, options)`** (imported):
    Pushes a new pane onto the specified group (or current group if `groupName` is omitted when used as a prop).
    *   `options`: An object, typically `{ src: "/path/to/page" }`. Can also include `initialComponent` etc.
*   **`replace(options)`** (as prop) or **`replace(groupName, options)`** (imported):
    Replaces the entire specified group with a single new pane defined by `options`.
*   **`recede()`** (as prop) or **`recede(groupName)`** (imported):
    Navigates one step back within the specified group (or current group). Does nothing if it's the first pane.
*   **`close()`** (as prop) or **`close(groupName)`** (imported):
    Closes/removes the entire specified group (or current group). Typically used for modal groups.

## Opting Out of NavStack Behavior

If you have a link that should *not* be handled by NavStack and should instead use the standard Inertia X click handling (or even be a full browser navigation), you can opt-out:

*   **`data-navstack-ignore`**: Add this attribute to a link (or one of its parent elements). NavStack will ignore clicks on this link, and Inertia X's default click handler will take over.
    ```html
    <a href="/some/page" data-navstack-ignore>Normal Inertia Link</a>
    ```
*   **`data-inertia-ignore`**: If you also want to bypass Inertia X's default click handling (making it a regular HTML link causing a full page load), add this attribute as well.
    ```html
    <a href="/logout" data-navstack-ignore data-inertia-ignore>Full Page Logout</a>
    ```

## Hints for Snappier Experiences (Instant Previews)

On slow connections, users might notice a delay as NavStack transitions a new pane in, waiting for the page component and its data to load from the server.

To make this feel much faster, you can provide an `initialComponent` and its initial props directly to the `navstack` action or programmatic navigation functions. NavStack will immediately render this initial component with the provided props while the "real" data is fetched from the server. Once the server responds, the initial component is seamlessly replaced with the actual page content.

**Example:**

Imagine a list of projects. Clicking a project link can instantly show a skeleton or basic version of the project page.

```svelte
<!-- projects/index.svelte -->
<script>
  // Assuming `projects` is an array of project objects
  // And you have a `pages/projects/show.svelte` component
  export let projects = [];
</script>

{#each projects as project}
  <a 
    href="/projects/{project.id}" 
    use:navstack={{
      initialComponent: import('~/pages/projects/show.svelte'), // The component to show instantly
      project // Rest props are passed through to the page component
    }}
  >
    {project.name}
  </a>
{/each}
```

When a user clicks a project link:
1.  The `~/pages/projects/show.svelte` component is rendered *immediately* using the `project` data you passed. This could be a simplified view or a loading state that uses `project.name`.
2.  In the background, NavStack (via Inertia X Frame) makes a request to `/projects/{project.id}`.
3.  Once the server responds with the full data for that project, the initial component is replaced with the fully-rendered project page.

This significantly improves the perceived performance of your application. These `initialComponent` and `props` options are passed to the underlying Inertia X `<Frame>` component.
