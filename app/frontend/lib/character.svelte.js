import { derived } from "svelte/store";
import { getStore } from "livestores";
import { Properties } from "$/properties.rb"	

let currentTime = $state(new Date().getTime() / 1000);
setInterval(() => {
  currentTime = new Date().getTime() / 1000;
}, 100);

export default derived(getStore("character"), (rawCharacter) => {
  if (!rawCharacter) return null;

  Object.defineProperties(rawCharacter, Object.getOwnPropertyDescriptors(Properties)) 
  Object.defineProperties(rawCharacter, Object.getOwnPropertyDescriptors({
    get current_time() {
        return currentTime
      },
      enumerable: true
    }
  ));
  return rawCharacter;
})