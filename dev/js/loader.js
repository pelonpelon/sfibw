var animationChain, defer, downloadJSAtOnload, fastClick, intro, logo, main, react, reactBootstrap, texthb, textyr, velocity, window;

console.log("loading loader");

window = this;

main = document.getElementsByClassName('main')[0];

logo = main.getElementsByClassName('logo')[0];

logo.style.opacity = 0;

textyr = logo.getElementsByClassName('text-yr')[0];

textyr.style.opacity = 0;

texthb = logo.getElementsByClassName('text-hb')[0];

texthb.style.opacity = 0;

intro = logo.getElementsByClassName('intro')[0];

intro.style.opacity = 0;

animationChain = function() {
  console.log("ANIMATING");
  $('.logo').on("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function() {
    $(this).off("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend");
    console.log("...intro");
    return setTimeout(function() {
      return $('.text-yr').addClass('animated fadeInUp');
    }, 500);
  });
  $('.text-yr').on("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function() {
    $(this).off("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend");
    console.log("...intro");
    return setTimeout(function() {
      return $('.intro').addClass('animated fadeIn');
    }, 500);
  });
  $('.intro').on("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function() {
    var isReactBootstrapLoaded, reactinterval;
    $(this).off("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend");
    console.log("...menu");
    isReactBootstrapLoaded = function() {
      var element;
      if (window.ReactBootstrap != null) {
        console.log("loading menu");
        element = document.createElement("script");
        element.src = "components/mainMenu.js";
        document.body.appendChild(element);
        return clearInterval(reactinterval);
      }
    };
    return reactinterval = setInterval(isReactBootstrapLoaded, 50);
  });
  return $('.logo').addClass('animated fadeInUp');
};

defer = function(cb, global) {
  if (window[global] != null) {
    console.log(global + " loaded");
    return cb();
  } else {
    return setTimeout(function() {
      return defer(cb, global);
    }, 50);
  }
};

downloadJSAtOnload = function() {
  var element, isJqueryLoaded, jqueryInterval;
  console.log("inside dl");
  element = document.createElement("link");
  element.href = "lib/bootstrap.min.css";
  element.rel = "stylesheet";
  document.head.appendChild(element);
  element = document.createElement("link");
  element.href = "views/mainMenu.css";
  element.rel = "stylesheet";
  document.head.appendChild(element);
  element = document.createElement("script");
  element.src = "lib/jquery.js";
  document.body.appendChild(element);
  isJqueryLoaded = function() {
    console.log("...");
    if (window.jQuery != null) {
      animationChain();
      return clearInterval(jqueryInterval);
    }
  };
  jqueryInterval = setInterval(isJqueryLoaded, 50);
  return defer(velocity, 'jQuery');
};

velocity = function() {
  var element;
  console.log('inside velocity');
  element = document.createElement("script");
  element.src = "lib/velocity.min.js";
  document.body.appendChild(element);
  return defer(react, 'velocity');
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
  element.src = "lib/react-bootstrap.js";
  document.body.appendChild(element);
  return defer(fastClick, 'ReactBootstrap');
};

fastClick = function() {
  var element;
  console.log("inside fastClick");
  element = document.createElement("script");
  element.src = "lib/fastclick.min.js";
  return document.body.appendChild(element);
};

if (window.addEventListener) {
  window.addEventListener("load", downloadJSAtOnload, false);
} else if (window.attachEvent) {
  window.attachEvent("onload", downloadJSAtOnload);
} else {
  window.onload = downloadJSAtOnload;
}
