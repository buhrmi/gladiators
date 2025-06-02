import { derived, toStore } from "svelte/store";
import { State, registerMutator, registerHook } from "activestate";
import { Properties } from "$/properties.rb"
import { Methods } from "$/methods.rb";	
import * as Constants from "$/constants.rb";
Object.assign(globalThis, Constants)

let currentTime = $state(new Date().getTime() / 1000);
setInterval(() => {
  currentTime = new Date().getTime() / 1000;
}, 100);

export default derived(toStore(() => State.character), augment)

const augmentedPool = {}
// whenever we receive a character update, intercept it and update the character
// in our pool of augmented characters
registerHook('characters.', function(path, action, data) {
  const id = path[1]
  if (augmentedPool[id]) Object.assign(augmentedPool[id], data);
  return false
})

// augments a raw json character object with properties and methods defined in properties.rb
export function augment(rawCharacter) {
  if (!rawCharacter) return null;
  if (rawCharacter.augmented) return rawCharacter;
  if (augmentedPool[rawCharacter.id]) {
    const augmentedCharacter = augmentedPool[rawCharacter.id];
    Object.assign(augmentedCharacter, rawCharacter);
    return augmentedCharacter
  }
  Object.setPrototypeOf(rawCharacter, Methods);
  Object.defineProperties(rawCharacter, Object.getOwnPropertyDescriptors(Properties)) 
  Object.defineProperties(rawCharacter, Object.getOwnPropertyDescriptors({
    get current_time() {
        return currentTime
      },
      enumerable: true
    }
  ));
  rawCharacter.augmented = true;
  augmentedPool[rawCharacter.id] = rawCharacter;
  return rawCharacter;
}

export const Time = {
  get current() {
    return currentTime;
  }
}