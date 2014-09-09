console.log("inside mainMenu")

Nav = ReactBootstrap.Nav
Navbar = ReactBootstrap.Navbar
NavItem = ReactBootstrap.NavItem
main = $('.main')
$('.main .content').addClass('animated')

fadeContent = ()->

  content = $('.main .content')
  title = $('.navbar-title')

  if ($('.in').is(":visible"))
    console.log 'in visible'
    content.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
    title.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
    content.addClass 'fadeInDim'
    title.addClass 'fadeInDim'

  else
    console.log 'not in visible'
    content.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
    title.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
    content.addClass 'fadeOutDim'
    title.addClass 'fadeOutDim'

loadView = (key)->
  nav = $('.collapse')

  if  currentKey == key
    $('.navbar-toggle').click()
    return

  console.log "key: "+currentKey+" to "+key
  currentKey = key
  content = $('.main .content')

  # Change title
  if $('.navbar-title').length
    title = $('.navbar-title')
    title.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
    title.addClass('fadeOut').remove()

  brand = $('.navbar-brand')
  brand.after "<div class='navbar-title' style='opacity:0'>"+key+"</div>"
  $('.navbar-title').addClass 'animated fadeIn'

  # mark item as .active
  items = $('.nav')
  items
    .find('.active')
    .removeClass('active')
  items
    .find(navitemClass)
    .addClass('active')

  # load new content
  view = "views/"+key
              .toLowerCase()
              .split(' ')
              .join('')+".html"
  navitemClass = ".navitem-"+key
  content
    .removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
    .addClass 'fadeOut'
    .load view
    .removeClass 'fadeOut'
  toggleButton = $('.navbar-toggle')
  console.log 'loadView done'

currentKey = "home"
switchView = (key)->
  if $('.navbar-title').length
    title = $('.navbar-title')
    title.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
    title.addClass('fadeOut').remove()

  brand = $('.navbar-brand')
  brand.after "<div class='navbar-title' style='opacity:0'>"+key+"</div>"
  $('.navbar-title').addClass 'animated fadeIn'

  # mark item as .active
  items = $('.navbar-nav')
  items
    .find('.active')
    .removeClass('active')
  items
    .find('.navitem-'+key.toLowerCase()+' a')
    .addClass('active')


  $('.'+currentKey).removeClass 'animated fadeIn'
  $('.'+currentKey).addClass('animated fadeOut').css('display', 'none')
  $('.'+key.toLowerCase()).removeClass 'animated fadeOut'
  $('.'+key.toLowerCase()).css('display', 'block').addClass 'animated fadeIn'
  currentKey = key.toLowerCase()

mainMenuComponent = (
    <Navbar
      toggleNavKey={"Home"}
      fixedTop={true}
      inverse={false}
      fluid={true}
      onToggle={fadeContent}
      brand={<a href="http:sf-eagle.com/sfibw/lab/index.html"></a>}
    >
      <Nav key={"Home"} collapsable>
        <NavItem key={"Home"} href="#" className="navitem-home" onSelect={switchView}>Home</NavItem>
        <NavItem key={"About"} href="#" className="navitem-about" onSelect={switchView}>About</NavItem>
        <NavItem key={"Transportation"} href="#" className="navitem-transportation" onSelect={switchView}>Transportation</NavItem>
        <NavItem key={"Lodging"} href="#" className="navitem-lodging" onSelect={switchView}>Lodging</NavItem>
        <NavItem key={"Schedule"} href="#" className="navitem-schedule" onSelect={switchView}>Schedule</NavItem>
        <NavItem key={"Bear Passes"} href="#" className="navitem-bearpasses" onSelect={switchView}>Bear Passes</NavItem>
        <NavItem key={"Connect"} href="#" className="navitem-connect" onSelect={switchView}>Connect</NavItem>
      </Nav>
    </Navbar>

  )


React.renderComponent mainMenuComponent, $('.menu')[0]
$('.navbar-brand').addClass 'icon'

console.log "finished mainMenu"
