console.log "loading loader"

window = this

main = document.getElementsByClassName('main')[0]
logo = main.getElementsByClassName('logo')[0]
textsf = logo.getElementsByClassName('text-sf')[0]
textbr = logo.getElementsByClassName('text-br')[0]
textyr = logo.getElementsByClassName('text-yr')[0]
texthb = logo.getElementsByClassName('text-hb')[0]
intro = logo.getElementsByClassName('intro')[0]

toBeAnimated = [textsf, textbr, textyr, texthb, intro]
toBeAnimated.forEach (el)->
  el.classList.add "animated"

pfx = ["webkit", "moz", "MS", "o", ""]
PrefixedEvent = (element, types, callback)->
  for t in types
    element.addEventListener t, callback, false

animationChain = ()->
  console.log "ANIMATING"

#  textsf.addEventListener "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
#    textsf.removeEventListener "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
#    console.log "...textsf"
#    setTimeout ()->
#      textbr.classList.add 'fadeInUp'
#    ,50
#
#  textbr.addEventListener "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
#    textbr.removeEventListener "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
#    console.log "...textbr"
#    setTimeout ()->
#      textyr.classList.add 'fadeInUp'
#    ,50
#
  # textyr.addEventListener "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", ()->
    # textyr.removeEventListener "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend"
    # console.log "...textyr"
    # setTimeout ()->
      # intro.classList.add 'fadeIn'
    # ,50

  LoadMenu = ()->
    isReactBootstrapLoaded = ->
      if window.$? && window.React? && window.ReactBootstrap?

        console.log "loading menu"
        element = document.createElement "script"
        element.src = "components.js"
        document.body.appendChild element

        # pages = ['about', 'transportation', 'lodging', 'schedule', 'bearPasses', 'signUp', 'social'  ]

        # for page in pages
          # $('.content').append('<div class="page '+page+'"></div>')
          # console.log "loading: "+ page
          # element = document.createElement "script"
          # element.src = "components/"+page+".js"
          # document.body.appendChild element

        clearInterval reactinterval

    reactinterval = setInterval(isReactBootstrapLoaded, 50)

    # isFastClickLoaded = ->
      # if window.fastClick?

        # window.fastClick.attach(document.body)
        # console.log "applied applyFastClick"

        # clearInterval fastclickinterval

    # fastclickinterval = setInterval(isFastClickLoaded 50)

  PrefixedEvent intro, ["webkitAnimationEnd", "mozAnimationEnd", "MSAnimationEnd", "oanimationend", "animationend"], LoadMenu

  interval = 20
  setTimeout ()->
    textsf.classList.add 'fadeInUp'
  ,interval
  setTimeout ()->
    textbr.classList.add 'fadeInUp'
  ,interval*20
  setTimeout ()->
    textyr.classList.add 'fadeInUp'
  ,interval*40
  setTimeout ()->
    intro.classList.add 'fadeIn'
  ,interval*60

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

  animationChain()

  element = document.createElement "link"
  element.href = "all.css"
  element.rel = "stylesheet"
  document.head.appendChild element


  element = document.createElement "script"
  element.src = "libs.js"
  document.body.appendChild element

  # element = document.createElement "script"
  # element.src = "lib/jquery.js"
  # element.src = "//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"
  # document.body.appendChild element

  # defer [velocity, react, fastClick], 'jQuery'
  # defer [reactBootstrap], 'React'
  # defer [applyFastClick], 'FastClick'


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

