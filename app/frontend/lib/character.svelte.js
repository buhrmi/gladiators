import { toStore } from "svelte/store";
import { State } from "activestate";
import { Properties } from "$/properties.rb"
import { Methods } from "$/methods.rb";	
import * as Constants from "$/constants.rb";
Object.assign(globalThis, Constants)

State.updates = [];

let currentTime = $state(new Date().getTime() / 1000);
setInterval(() => {
  currentTime = new Date().getTime() / 1000;
}, 100);

const characterPool = {}

const augmentedChar = $derived(augment(State.character))
export default toStore(() => augmentedChar);

$effect.root(() => {
  $effect(() => {
    State.updates.splice(0).forEach((update) => {
      if (!characterPool[update.id]) return;
      Object.assign(characterPool[update.id], update)
    })
  })
});

// augments a raw json character object with properties and methods defined in properties.rb
export function augment(rawCharacter) {
  if (!rawCharacter) return null;
  if (rawCharacter.augmented) return rawCharacter;
  if (characterPool[rawCharacter.id]) {
    const augmentedCharacter = characterPool[rawCharacter.id];
    Object.assign(augmentedCharacter, rawCharacter);
    return augmentedCharacter
  }
  const augmentedCharacter = Object.assign({}, rawCharacter);
  Object.setPrototypeOf(augmentedCharacter, Methods);
  Object.defineProperties(augmentedCharacter, Object.getOwnPropertyDescriptors(Properties)) 
  Object.defineProperties(augmentedCharacter, Object.getOwnPropertyDescriptors({
    get current_time() {
        return currentTime
      },
      enumerable: true
    }
  ));
  augmentedCharacter.augmented = true;
  characterPool[augmentedCharacter.id] = augmentedCharacter;
  return augmentedCharacter;
}

export const Time = {
  get current() {
    return currentTime;
  }
}