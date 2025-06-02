import { derived, get } from "svelte/store";
import { getStore } from "livestores";
import { Properties } from "$/properties.rb"
import { Methods } from "$/methods.rb";	
import * as Constants from "$/constants.rb";
Object.assign(globalThis, Constants)

let currentTime = $state(new Date().getTime() / 1000);
setInterval(() => {
  currentTime = new Date().getTime() / 1000;
}, 100);

export default derived(getStore("character"), augment)

// augments a raw json character object with properties and methods defined in properties.rb
export function augment(rawCharacter) {
  if (!rawCharacter) return null;
  
  Object.setPrototypeOf(rawCharacter, Methods);
  Object.defineProperties(rawCharacter, Object.getOwnPropertyDescriptors(Properties)) 
  Object.defineProperties(rawCharacter, Object.getOwnPropertyDescriptors({
    get current_time() {
        return currentTime
      },
      enumerable: true
    }
  ));

  return rawCharacter;
}

export const Time = {
  get current() {
    return currentTime;
  }
}