console.log "loading loader"

window = this
###
# Update appcache (REMOVE THIS WHEN SITE IS STABLE)
appCache = window.applicationCache
appCache.update() # Attempt to update the user's cache.

if appCache.status == window.applicationCache.UPDATEREADY
  appCache.swapCache()  # The fetch was successful, swap in the new cache.

# Check if a new cache is available on page load.
window.addEventListener('load', (e)->

  window.applicationCache.addEventListener('updateready', (e)->
    if window.applicationCache.status == window.applicationCache.UPDATEREADY
      # Browser downloaded a new app cache.
      if confirm('A new version of this site is available. Load it?')
        window.location.reload()
    else
      #Manifest didn't changed. Nothing new to server.
  ,false)

,false)
###

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

  interval = 30
  setTimeout ()->
    textsf.classList.add 'fadeInUp'
  ,interval
  setTimeout ()->
    textbr.classList.add 'fadeInUp'
  ,interval*20
  setTimeout ()->
    texthb.classList.add 'fadeInUp'
  ,interval*40
  setTimeout ()->
    intro.classList.add 'fadeIn'
  ,interval*60
  setTimeout ()->
    texthb.classList.remove 'fadeInUp'
    texthb.classList.add 'fadeOutRightBig'
  ,interval*150
  setTimeout ()->
    textyr.classList.add 'fadeInLeftBig'
  ,interval*100
  mq = window.matchMedia('(min-width: 800px)')
  console.log mq
  setTimeout ()->
    console.log 'setting timeout'
    if mq.matches
      console.log 'mq.matches'

      news = document.getElementsByClassName('news')[0]
      news.classList.add 'animated'
      news.classList.add 'fadeInLeftBig'

      db = document.getElementsByClassName('dancing-bear')[0]
      db.setAttribute('src', 'dancing-bear-polar.gif?' + Math.random())
      db.style.display = 'block'
      db.classList.add 'animated'
      db.classList.add 'zoomInUp'
      db.style.opacity = 1

  ,interval*120


LoadComponents = ->
  if window.$? && window.React? && window.ReactBootstrap?

    console.log "loading components"
    element = document.createElement "script"
    element.src = "components.js"
    document.body.appendChild element

    clearInterval reactinterval

reactinterval = setInterval(LoadComponents, 50)

ApplyFastClick = ->
  if window.FastClick?

    console.log "loading FastClick"
    fc = window.FastClick.attach(document.body)
    console.log "applied FastClick to: "+fc.layer

    clearInterval fastclickinterval

fastclickinterval = setInterval(ApplyFastClick, 50)

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

