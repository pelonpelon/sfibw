console.log "loading loader"

window = this

main = document.getElementsByClassName('main')[0]
home = main.getElementsByClassName('home')[0]
home.style.display = 'block'
home.style.opacity = 1
textsf = home.getElementsByClassName('text-sf')[0]
textbr = home.getElementsByClassName('text-br')[0]
textyr = home.getElementsByClassName('text-yr')[0]
texthb = home.getElementsByClassName('text-hb')[0]
intro = home.getElementsByClassName('intro')[0]

toBeAnimated = [textsf, textbr, textyr, texthb, intro]
toBeAnimated.forEach (el)->
  el.classList.add "animated"

AnimationChain = ()->
  console.log "ANIMATING"

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

LoadComponents = ->
  if window.$? && window.React? && window.ReactBootstrap?

    console.log "loading menu"
    element = document.createElement "script"
    element.src = "components.js"
    document.body.appendChild element

    clearInterval reactinterval

reactinterval = setInterval(LoadComponents, 50)

ApplyFastClick = ->
  if window.fastClick?

    window.fastClick.attach(document.body)
    console.log "applied applyFastClick"

    clearInterval fastclickinterval

fastclickinterval = setInterval(ApplyFastClick 50)

StartApp = ->
  console.log "inside dl"

  AnimationChain()

  element = document.createElement "link"
  element.href = "all.css"
  element.rel = "stylesheet"
  document.head.appendChild element

  element = document.createElement "script"
  element.src = "libs.js"
  document.body.appendChild element

if  window.addEventListener
  window.addEventListener "load", StartApp, false
else if  window.attachEvent
  window.attachEvent "onload", StartApp
else
  window.onload = StartApp

