var defer, downloadJSAtOnload, gsap, jquery, logo, main, mainLoad, mainSetup, react, reactBootstrap, splash, window;

console.log("splash.coffee loading");

window = this;

main = document.getElementsByClassName('main')[0];

main.style.opacity = 0;

main.classList.add('fade1');

splash = document.getElementsByClassName('splash')[0];

logo = splash.getElementsByClassName('logo')[0];

logo.style.opacity = 0;

logo.classList.add('fade1');

logo.addEventListener("transitionend", function() {
  console.log("logo loaded");
  return window.logoloaded = true;
}, false);

main.addEventListener("transitionend", function() {
  var element;
  console.log("main loaded");
  element = document.createElement("script");
  element.src = "components/mainMenu.js";
  document.body.appendChild(element);
  $('.logo').css('background-image', 'none');
  return console.log("menu loaded");
}, false);

setTimeout(function() {
  return logo.style.opacity = 1;
}, 500);

defer = function(cb, global) {
  console.log(global);
  if (window[global]) {
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
  element.href = "main.css";
  element.rel = "stylesheet";
  document.head.appendChild(element);
  return jquery();
};

jquery = function() {
  var element;
  console.log("inside jquery");
  element = document.createElement("script");
  element.src = "lib/jquery.min.js";
  document.body.appendChild(element);
  return defer(react, 'jQuery');
};

react = function() {
  var element;
  console.log("inside react");
  element = document.createElement("script");
  element.src = "lib/react.js";
  document.body.appendChild(element);
  return defer(reactBootstrap, 'React');
};

reactBootstrap = function() {
  var element;
  console.log("inside reactBootstrap");
  element = document.createElement("script");
  element.src = "lib/react-bootstrap.min.js";
  document.body.appendChild(element);
  return defer(gsap, 'ReactBootstrap');
};

gsap = function() {
  var element, lib, _i, _len, _ref;
  console.log("inside gsap");
  _ref = ["lib/jquery.gsap.min.js", "lib/TweenLite.min.js", "lib/EasePack.min.js", "lib/CSSPlugin.min.js"];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    lib = _ref[_i];
    element = document.createElement("script");
    element.src = lib;
    document.body.appendChild(element);
  }
  return defer(mainSetup, 'TweenLite');
};

mainSetup = function() {
  console.log("inside mainSetup");
  main = $('.main');
  main.load("main.html");
  return defer(mainLoad, 'logoloaded');
};

mainLoad = function() {
  var element;
  console.log("inside main");
  element = document.createElement("script");
  element.src = "main.js";
  document.body.appendChild(element);
  document.getElementsByClassName('main')[0].style.opacity = 1;
  return console.log("splash.coffee loaded");
};

if (window.addEventListener) {
  window.addEventListener("load", downloadJSAtOnload, false);
} else if (window.attachEvent) {
  window.attachEvent("onload", downloadJSAtOnload);
} else {
  window.onload = downloadJSAtOnload;
}
