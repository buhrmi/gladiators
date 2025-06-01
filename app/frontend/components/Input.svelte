<script>
  let {
    value = $bindable(),
    error = $bindable(),
    element = $bindable(),
    label,
    el="input",
    ...props
  } = $props();
</script>

<label class="input" class:error>
  <div class="label">
    {label}
    {error}
  </div>

  {#if el === "textarea"}
    <textarea
      bind:value
      bind:this={element}   
      onfocus={() => (error = null)}
      placeholder=" "       
      autocomplete="off"
      class:placeholder = {props.placeholder}
      {...props}
    ></textarea>
  {:else}
    <input
      bind:value
      bind:this={element}   
      onfocus={() => (error = null)}
      placeholder = " "       
      autocomplete="off"
      class:noplaceholder = {!props.placeholder}
      {...props}     
    />
  {/if}
</label>

<style>
input {
  width: 100%;
}
.input {
  display: block;
  margin-bottom: 1em;
  border: 1px solid var(--color-border);
  padding: 0.5em 1em;
  border-radius: 1em;
}
.input.error {
  border-color: rgb(193, 72, 72);
}
.input .label {
  cursor: text;
  display: block;
  text-transform: uppercase;
  pointer-events: none;
  user-select: none;
  font-size: 0.8em;
  color: var(--color-muted);
  transition: transform 0.2s ease-in-out;
}
.input.error .label {
  color: rgb(193, 72, 72);
}

.input input,
.input textarea {
  width: 100%;
  border: none;
  outline: none;
  background-color: transparent;
  /* text-align: center; */
}
.input .helper {
  display: none;
}
.input:has(input:not(:placeholder-shown)) {
  .helper {
    display: block;
  }
}
.input:has(input:focus) {
  border-color: var(--color-border-focus);
  .label {
    transform: translateY(0);
  }
  .helper {
    display: block;
  }
}
.input:has(input.noplaceholder:placeholder-shown:not(:focus)) .label,
.input:has(textarea.noplaceholder:placeholder-shown:not(:focus)) .label { 
  transform: translateY(1em);
}
input, textarea {
  background: transparent;
  border: none;
}
input:focus, textarea:focus {
  outline: none;
}
</style>