console.log "splash.coffee loading"
window = this

main = document.getElementsByClassName('main')[0]
main.style.opacity = 0
main.classList.add 'fade1'

splash = document.getElementsByClassName('splash')[0]
logo = splash.getElementsByClassName('logo')[0]
logo.style.opacity = 0
logo.classList.add 'fade1'

logo.addEventListener("transitionend", ->
  console.log "logo loaded"
  window.logoloaded = true
, false)
main.addEventListener("transitionend", ->
  console.log "main loaded"
  element = document.createElement "script"
  element.src = "components/mainMenu.js"
  document.body.appendChild element
  $('.logo').css('background-image', 'none')
  console.log "menu loaded"
, false)
setTimeout ()->
  logo.style.opacity = 1
,500


# textsf = splash.getElementsByClassName('text-sf')[0]
# textsf.style.opacity = 0
# textsf.classList.add 'fade1'
# textbr = splash.getElementsByClassName('text-br')[0]
# textbr.style.opacity = 0
# textbr.classList.add 'fade1'
# textyr = splash.getElementsByClassName('text-yr')[0]
# textyr.style.opacity = 0
# textyr.classList.add 'fade1'


# window.setTimeout '500', ->
  # textsf.style.opacity = 1

# window.setTimeout '800', ->
  # textbr.style.opacity = 1

# window.setTimeout '1100', ->
  # textyr.style.opacity = 1

defer = (cb, global)->
  console.log global
  if window[global]
    cb()
  else
    setTimeout ()->
      defer(cb, global)
    ,50

downloadJSAtOnload = ->
  console.log "inside dl"

  element = document.createElement "link"
  element.href = "main.css"
  element.rel = "stylesheet"
  document.head.appendChild element

  jquery()

jquery = ->
  console.log "inside jquery"

  element = document.createElement "script"
  element.src = "lib/jquery.min.js"
  # element.src = "//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"
  document.body.appendChild element

  defer react, 'jQuery'

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
  element.src = "lib/react-bootstrap.min.js"
  document.body.appendChild element

  defer gsap, 'ReactBootstrap'

gsap = ->
  console.log "inside gsap"

  for lib in [
    "lib/jquery.gsap.min.js"
    "lib/TweenLite.min.js"
    "lib/EasePack.min.js"
    "lib/CSSPlugin.min.js"
  ]
    element = document.createElement "script"
    element.src = lib
    document.body.appendChild element

  defer mainSetup, 'TweenLite'

mainSetup = ->
  console.log "inside mainSetup"

  main = $('.main')
  main.load "main.html"

  defer mainLoad, 'logoloaded'

mainLoad = ->
  console.log "inside main"

  element = document.createElement "script"
  element.src = "main.js"
  document.body.appendChild element

  document.getElementsByClassName('main')[0].style.opacity = 1

  console.log "splash.coffee loaded"

if  window.addEventListener
  window.addEventListener "load", downloadJSAtOnload, false
else if  window.attachEvent
  window.attachEvent "onload", downloadJSAtOnload
else
  window.onload = downloadJSAtOnload

