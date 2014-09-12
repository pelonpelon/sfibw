console.log("inside mainMenu")

Nav = ReactBootstrap.Nav
Navbar = ReactBootstrap.Navbar
NavItem = ReactBootstrap.NavItem
main = $('.main')
$('.main .content').addClass('animated')
toggle = $('.navbar-toggle')

fadeContent = (e)->

  console.log "evt: "+e
  console.log e

  # collapse = $('.collapse')
  collapse = document.getElementsByTagName('nav')[1]
  toggle = $('.navbar-toggle').css('display')
  if toggle != "none"

    content = $('.main .content')
    title = $('.navbar-title')

    if collapse.style.height == '0px'
      console.log 'not visible'
      content.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
      title.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
      content.addClass 'fadeOutDim'
      title.addClass 'fadeOutDim'
      menuClickArea = $('.navbar')[0]
      fc = FastClick.attach(menuClickArea)
      console.log "FastClick attached to: "+fc.layer

    else
      console.log 'visible'
      content.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
      title.removeClass 'fadeIn fadeOut fadeInDim fadeOutDim'
      content.addClass 'fadeInDim'
      title.addClass 'fadeInDim'
      mainClickArea = $('.main')[0]
      fc = FastClick.attach(mainClickArea)
      console.log "FastClick attached to: "+fc.layer
      if not $('.collapse.in')[0]
        collapse.style.height = '0px'

currentKey = "home"
switchView = (key)->

  toggle = $('.navbar-toggle').css('display')
  console.log "toggle: "+toggle
  if toggle != "none"

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
      defaultNavExpanded={true}
      navExpanded={true}
      brand={<a href="http://sf-eagle.com/sfibw/lab/index.html"></a>}
    >
      <Nav key={"Home"}>
        <NavItem key={"Home"} href="#" className="navitem-home" onSelect={switchView}>Home</NavItem>
        <NavItem key={"Schedule"} href="#" className="navitem-schedule" onSelect={switchView}>Schedule</NavItem>
        <NavItem key={"Connect"} href="#" className="navitem-connect" onSelect={switchView}>Connect</NavItem>
        <NavItem key={"BearTags"} href="#" className="navitem-beartags" onSelect={switchView}>Bear Tags</NavItem>
        <NavItem key={"SpecialDeals"} href="#" className="navitem-specialdeals" onSelect={switchView}>Special Deals</NavItem>
        <NavItem key={"Lodging"} href="#" className="navitem-lodging" onSelect={switchView}>Lodging</NavItem>
        <NavItem key={"Transportation"} href="#" className="navitem-transportation" onSelect={switchView}>Transport</NavItem>
      </Nav>
    </Navbar>

  )


React.renderComponent mainMenuComponent, $('.menu')[0]
$('.navbar-brand').addClass 'icon'

console.log "finished mainMenu"
