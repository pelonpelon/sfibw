console.log "loading loader"

window = this

main = document.getElementsByClassName('main')[0]
logo = main.getElementsByClassName('logo')[0]
logo.style.opacity = 0
textyr = logo.getElementsByClassName('text-yr')[0]
textyr.style.opacity = 0
texthb = logo.getElementsByClassName('text-hb')[0]
texthb.style.opacity = 0
intro = logo.getElementsByClassName('intro')[0]
intro.style.opacity = 0

animationChain = ()->
  console.log "ANIMATING"

  $('.logo').on "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
    $(this).off "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
    console.log "...intro"
    setTimeout ()->
      $('.text-yr').addClass 'animated fadeInUp'
    ,500

  $('.text-yr').on "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
    $(this).off "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
    console.log "...intro"
    setTimeout ()->
      $('.intro').addClass 'animated fadeIn'
    ,500

  $('.intro').on "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
    $(this).off "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
    console.log "...menu"
    isReactBootstrapLoaded = ->
      if window.ReactBootstrap?
        console.log "loading menu"
        element = document.createElement "script"
        element.src = "components/mainMenu.js"
        document.body.appendChild element
        clearInterval reactinterval
    reactinterval = setInterval(isReactBootstrapLoaded, 50)

  $('.logo').addClass 'animated fadeInUp'

defer = (cb, global)->
  if window[global]?
    console.log global+" loaded"
    cb()
  else
    setTimeout ->
      defer(cb, global)
    ,50

downloadJSAtOnload = ->
  console.log "inside dl"

  element = document.createElement "link"
  element.href = "lib/bootstrap.min.css"
  element.rel = "stylesheet"
  document.head.appendChild element

  element = document.createElement "link"
  element.href = "views/mainMenu.css"
  element.rel = "stylesheet"
  document.head.appendChild element

  element = document.createElement "script"
  element.src = "lib/jquery.js"
  # element.src = "//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"
  document.body.appendChild element

  isJqueryLoaded = ->
    console.log "..."
    if window.jQuery?
      animationChain()
      clearInterval jqueryInterval
  jqueryInterval = setInterval(isJqueryLoaded,50)

  defer velocity, 'jQuery'


velocity = ->
  console.log 'inside velocity'

  element = document.createElement "script"
  # element.src ="//cdn.jsdelivr.net/velocity/1.0.0/velocity.min.js"
  element.src = "lib/velocity.min.js"
  document.body.appendChild element

  defer react, 'velocity'


react = ->
  console.log "inside react"

  element = document.createElement "script"
  # element.src = "//cdnjs.cloudflare.com/ajax/libs/react/0.11.1/react.min.js"
  element.src = "lib/react.js"
  document.body.appendChild element

  defer reactBootstrap, 'React'

reactBootstrap = ->
  console.log "inside reactBootstrap"

  element = document.createElement "script"
  element.src = "lib/react-bootstrap.js"
  document.body.appendChild element

  defer fastClick, 'ReactBootstrap'

fastClick = ->
  console.log "inside fastClick"

  element = document.createElement "script"
  element.src = "lib/fastclick.min.js"
  document.body.appendChild element

  # defer applyFastClick, 'FastClick'

# applyFastClick = ->
  # console.log "inside applyFastClick"

  # $( ->
      # FastClick.attach(document.body)
  # )


if  window.addEventListener
  window.addEventListener "load", downloadJSAtOnload, false
else if  window.attachEvent
  window.attachEvent "onload", downloadJSAtOnload
else
  window.onload = downloadJSAtOnload

