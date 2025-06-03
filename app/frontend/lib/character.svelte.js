import { toStore } from "svelte/store";
import { State } from "activestate";

// Isomorphic logic shared between ruby and js
import { Properties } from "$/properties.rb"
import { Methods } from "$/methods.rb";	
import * as Constants from "$/constants.rb";
Object.assign(globalThis, Constants)

// It's not possible to change the prototype of objects inside ActiveState's State,
// so we create an extra pool where we store the augmented characters.
const characterPool = {}
State.updates = [];

let currentTime = $state(new Date().getTime() / 1000);
setInterval(() => {
  currentTime = new Date().getTime() / 1000;
}, 100);


const augmentedChar = $derived(augment(State.character))
export default toStore(() => augmentedChar);

// Whenever we receive updates from the server, we apply them to the character pool.
$effect.root(() => {
  $effect(() => {
    State.updates.splice(0).forEach((update) => {
      if (!characterPool[update.id]) return;
      Object.assign(characterPool[update.id], update)
    })
  })
});

// creates an augmented version of the raw json character, adds it to the character pool, and returns it
export function augment(rawCharacter) {
  if (!rawCharacter) return null;

  // check if we already have this character in the pool
  if (characterPool[rawCharacter.id]) {
    const augmentedCharacter = characterPool[rawCharacter.id];
    Object.assign(augmentedCharacter, rawCharacter);
    return augmentedCharacter
  }

  // create a new augmented character and add it to the pool
  const augmentedCharacter = Object.assign({}, rawCharacter);
  Object.setPrototypeOf(augmentedCharacter, Methods);
  Object.defineProperties(augmentedCharacter, Object.getOwnPropertyDescriptors(Properties)) 
  Object.defineProperty(augmentedCharacter, "current_time", {
    get() {
        return currentTime
      },
      enumerable: true
    }
  );
  characterPool[augmentedCharacter.id] = augmentedCharacter;
  return augmentedCharacter;
}
