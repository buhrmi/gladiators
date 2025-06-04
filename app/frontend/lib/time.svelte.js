let currentTime = $state(new Date().getTime() / 1000);
setInterval(() => {
  currentTime = new Date().getTime() / 1000;
}, 100);


const Time = {
  current_time() {
    return currentTime;
  }
};

export default Time