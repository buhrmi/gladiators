<script>
  import Input from './Input.svelte';

  let { value = $bindable('') } = $props();

  let digits = $state(['', '', '', '', '', '']);
  let inputElements = $state([]);

  // Combine digits into the final code
  $effect(() => {
    value = digits.join('');
  });

  // Split initial value into digits if provided
  $effect(() => {
    if (value && value.length === 6 && digits.join('') !== value) {
        digits = value.split('');
    }
  });


  function handleInput(index, event) {
    // Ensure only one digit per input
    if (digits[index].length > 1) {
      digits[index] = digits[index].slice(-1);
    }

    // Move focus forward if a digit was entered and it's not the last input
    if (digits[index] && index < 5) {
      inputElements[index + 1]?.focus();
    }
  }

  function handleKeydown(index, event) {
    // Move focus backward on backspace if the input is empty and not the first input
    if (event.key === 'Backspace' && !digits[index] && index > 0) {
      inputElements[index - 1]?.focus();
    }
  }

  function handlePaste(event) {
    event.preventDefault();
    const pasteData = event.clipboardData?.getData('text').slice(0, 6);
    if (pasteData && /^\d+$/.test(pasteData)) {
        const pasteDigits = pasteData.split('');
        for (let i = 0; i < Math.min(pasteDigits.length, 6); i++) {
            digits[i] = pasteDigits[i];
        }
        // Focus the next empty input or the last one
        const nextIndex = Math.min(pasteDigits.length, 5);
        inputElements[nextIndex]?.focus();
    }
  }

</script>

<div class="code-input" onpaste={handlePaste}>
  {#each { length: 6 } as _, i}
    <Input
      bind:value={digits[i]}
      bind:element={inputElements[i]}
      type="tel"  
      maxlength={1}
      oninput={(e) => handleInput(i, e)}
      onkeydown={(e) => handleKeydown(i, e)}
      aria-label={`Digit ${i + 1}`}
    />
  {/each}
</div>

<style>
  .code-input {
    display: flex;
    gap: 0.5em; /* Space between inputs */
    justify-content: center;
  }

  .code-input :global(.input) {
    flex: 1 1 0; /* Allow inputs to grow/shrink */
    max-width: 3em; /* Limit width */
    margin-bottom: 0; /* Remove default margin */
    padding: 0.5em;
    aspect-ratio: 1 / 1; /* Make them square-ish */
  }

  .code-input :global(.label) {
    display: none; /* Hide default label */
  }

  .code-input :global(input) {
    font-size: 1.5em; /* Larger font for digits */
    text-align: center;
    padding: 0; /* Remove default input padding */
    line-height: 1; /* Adjust line height */
    height: 100%; /* Fill the container */
  }
</style>
