var defer, downloadJSAtOnload, logo, main, react, reactBootstrap, splash, window;

console.log("splash.coffee loading");

window = this;

main = document.getElementsByClassName('main')[0];

main.style.opacity = 0;

main.classList.add('fade');

splash = document.getElementsByClassName('splash')[0];

logo = splash.getElementsByClassName('logo')[0];

logo.style.opacity = 0;

logo.classList.add('fade');

window.setTimeout('1000');

logo.style.opacity = 1;

defer = function(cb, global) {
  if (window[global]) {
    console.log(global + " loaded");
    return cb();
  } else {
    return setTimeout(function() {
      return defer(cb, global);
    }, 50);
  }
};

downloadJSAtOnload = function() {
  var element;
  console.log("inside dl");
  element = document.createElement("link");
  element.href = "lib/bootstrap.min.css";
  element.rel = "stylesheet";
  document.head.appendChild(element);
  element = document.createElement("link");
  element.href = "main.css";
  element.rel = "stylesheet";
  document.head.appendChild(element);
  element = document.createElement("script");
  element.src = "lib/jquery.min.js";
  document.body.appendChild(element);
  return defer(react, 'jQuery');
};

react = function() {
  var element;
  console.log("inside react");
  element = document.createElement("script");
  element.src = "lib/react.min.js";
  document.body.appendChild(element);
  return defer(reactBootstrap, 'React');
};

reactBootstrap = function() {
  var element;
  console.log("inside reactbootstrap");
  element = document.createElement("script");
  element.src = "lib/react-bootstrap.min.js";
  document.body.appendChild(element);
  return defer(main, 'ReactBootstrap');
};

main = function() {
  var element;
  console.log("inside main");
  element = document.createElement("script");
  element.src = "components/mainNav.js";
  document.body.appendChild(element);
  main = $('.main');
  main.load("main.html");
  element = document.createElement("script");
  element.src = "main.js";
  return document.body.appendChild(element);
};

if (window.addEventListener) {
  window.addEventListener("load", downloadJSAtOnload, false);
} else if (window.attachEvent) {
  window.attachEvent("onload", downloadJSAtOnload);
} else {
  window.onload = downloadJSAtOnload;
}

window.onload = function() {
  return console.log("splash.coffee loaded");
};
