console.log "inside news"

Panel = ReactBootstrap.Panel

getNews = ->
  console.log "trying to get news"
  $.ajax
    url: "news.html"
  .success (text)->
    console.log "got news"
    $('.newsbox').append text


newsComponent = (
  <Panel>
    <div className="newsbox"></div>
  </Panel>
)

React.renderComponent newsComponent, $('.news')[0]
getNews()
