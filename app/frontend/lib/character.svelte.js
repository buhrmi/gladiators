import { State } from "activestate";

import Time from "~/lib/time.svelte.js";

// Isomorphic logic shared between ruby and js
import {Formulas} from "$/formulas.rb"


const augmentedCharacters = {};
State.updates = [];

// export const character = toStore($derived(augmentedCharacters[State.character_id]))

$effect.root(() => {
  $effect(() => {
    State.character = augmentedCharacters[State.character_id]
  });
})

// Whenever we receive updates from the server, we apply them to the character pool.
$effect.root(() => {
  $effect(() => {
    State.updates.splice(0).forEach(augment)
  })
});

// creates an augmented version of the raw json character, adds it to the character pool, and returns it
export function augment(character) {
  if (!character) return null;

  // If the character is already augmented, return it
  if (augmentedCharacters[character.id]) {
    return Object.assign(augmentedCharacters[character.id], character);
  }

  const augmentedCharacter = $state(
    Object.assign($state.snapshot(character), Formulas, Time)
  )
 
  return augmentedCharacters[character.id] = augmentedCharacter;

}
