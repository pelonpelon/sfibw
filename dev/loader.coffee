console.log "loading loader"

window = this

main = document.getElementsByClassName('main')[0]
logo = main.getElementsByClassName('logo')[0]
textyr = logo.getElementsByClassName('text-yr')[0]
texthb = logo.getElementsByClassName('text-hb')[0]
intro = logo.getElementsByClassName('intro')[0]

animationChain = ()->
  console.log "ANIMATING"

  $('.text-sf').addClass 'animated fadeInUp'

  $('.text-sf').on "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
    $(this).off "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
    console.log "...intro"
    setTimeout ()->
      $('.text-br').addClass 'animated fadeInUp'
    ,50

  $('.text-br').on "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
    $(this).off "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
    console.log "...intro"
    setTimeout ()->
      $('.text-yr').addClass 'animated fadeInUp'
    ,50

  $('.text-yr').on "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
    $(this).off "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
    console.log "...intro"
    setTimeout ()->
      $('.intro').addClass 'animated fadeIn'
    ,50

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
        # if window.ReactBootstrap?
          # setTimeout ()->
            # $('.menu').addClass 'animated fadeIn'
          # ,50
    reactinterval = setInterval(isReactBootstrapLoaded, 50)

  $('.logo').addClass 'animated fadeInUp'

defer = (cbs, global)->
  if window[global]?
    console.log "loaded: "+global
    while cbs.length
      cb = cbs.shift()
      cb()
  else
    setTimeout ->
      defer(cbs, global)
    ,50

downloadJSAtOnload = ->
  console.log "inside dl"

  # element = document.createElement "link"
  # element.href = "lib/bootstrap.min.css"
  # element.rel = "stylesheet"
  # document.head.appendChild element

  element = document.createElement "link"
  element.href = "all.css"
  element.rel = "stylesheet"
  document.head.appendChild element

  element = document.createElement "script"
  element.src = "lib/jquery.js"
  # element.src = "//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"
  document.body.appendChild element

  defer [animationChain, velocity, react, fastClick], 'jQuery'
  defer [reactBootstrap], 'React'
  defer [applyFastClick], 'FastClick'


velocity = ->
  console.log 'inside velocity'

  element = document.createElement "script"
  # element.src ="//cdn.jsdelivr.net/velocity/1.0.0/velocity.min.js"
  element.src = "lib/velocity.min.js"
  document.body.appendChild element

react = ->
  console.log "inside react"

  element = document.createElement "script"
  # element.src = "//cdnjs.cloudflare.com/ajax/libs/react/0.11.1/react.min.js"
  element.src = "lib/react.js"
  document.body.appendChild element


reactBootstrap = ->
  console.log "inside reactBootstrap"

  element = document.createElement "script"
  element.src = "lib/react-bootstrap.js"
  document.body.appendChild element

fastClick = ->
  console.log "inside fastClick"

  element = document.createElement "script"
  element.src = "lib/fastclick.min.js"
  document.body.appendChild element

applyFastClick = ->
  console.log "inside applyFastClick"

  $( ->
      FastClick.attach(document.body)
  )
  console.log "applied applyFastClick"

if  window.addEventListener
  window.addEventListener "load", downloadJSAtOnload, false
else if  window.attachEvent
  window.attachEvent "onload", downloadJSAtOnload
else
  window.onload = downloadJSAtOnload

