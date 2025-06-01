const localesLong = {
  prefix: "",
  ago: "ago",
  from_now: "",

  seconds: "less than a minute",
  minute: "about a minute",
  minutes: "%d minutes",
  hour: "about an hour",
  hours: "about %d hours",
  day: "a day",
  days: "%d days",
  month: "about a month",
  months: "%d months",
  year: "about a year",
  years: "%d years",
};

const locales = {
  prefix: "",
  ago: "",
  from_now: "",

  seconds: "now",
  minute: "1m",
  minutes: "%dm",
  hour: "1h",
  hours: "%dh",
  day: "1d",
  days: "%dd",
  month: "1m",
  months: "%dm",
  year: "1y",
  years: "%dy",
};

const timeInWords = function (timeAgo) {
  var seconds = Math.floor((new Date() - new Date(timeAgo)) / 1000),
    separator = locales.separator || " ",
    words = locales.prefix + separator,
    interval = 0,
    intervals = {
      year: Math.abs(seconds) / 31536000,
      month: Math.abs(seconds) / 2592000,
      day: Math.abs(seconds) / 86400,
      hour: Math.abs(seconds) / 3600,
      minute: Math.abs(seconds) / 60,
    };

  var distance = locales.seconds;

  for (var key in intervals) {
    interval = Math.floor(intervals[key]);

    if (interval > 1) {
      distance = locales[key + "s"];
      break;
    } else if (interval === 1) {
      distance = locales[key];
      break;
    }
  }

  distance = distance.replace(/%d/i, interval);
  if (seconds >= 0) {
    words += distance + separator + locales.ago;
  } else {
    words += distance + separator + locales.from_now;
  }

  return words.trim();
};

export {timeInWords};

globalThis.Time = {
  get current() {
    return new Date().getTime() / 1000;
  }
}