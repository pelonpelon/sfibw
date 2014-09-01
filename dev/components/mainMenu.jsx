console.log("inside mainMenu");

var Nav = ReactBootstrap.Nav;
var Navbar = ReactBootstrap.Navbar;
var NavItem = ReactBootstrap.NavItem;
var renderedInstance;


function loadView (key) {
  $('.nav').find('.active').removeClass('active');
  var navitem = ".navitem-"+key;
  $('.nav').find(navitem).addClass('active');
  var nt = $('.navbar-toggle');
  if ($('.in').is(":visible")){
    nt.click();
  }
  console.log(key);
  var view = "views/"+key.toLowerCase().split(' ').join('')+".html";
  $('.main .content').load(view);
  $('.navbar-title').remove();
  $('.navbar-brand').after("<div class='navbar-title'>"+key+"</div>");
}
function fadeContent () {
  var c = $('.main .content');
  var t = $('.navbar-title');

  if( c.css("opacity") > .99 ) {
    c.css('opacity', 0.4);
    t.css('opacity', 0.4);
    /* TweenLite.to(c, 0.4, {opacity:0.3}); */
  }
  else {
    /* TweenLite.to(c, 1, {opacity:1}); */
    c.css('opacity', 1);
    t.css('opacity', 1);
  }
}

var navbarInstance = (
    <Navbar
      toggleNavKey={"about"}
      fixedTop={true}
      inverse={false}
      fluid={true}
      onToggle={fadeContent}
      brand={<a href="http://sf-eagle.com/sfibw/lab/index.html">sfBR</a>}
    >
      <Nav key={"about"} >
        <NavItem key={"About"} href="#jj" className="navitem-about" onSelect={loadView}>About</NavItem>
        <NavItem key={"Transportation"} href="#" className="navitem-transportation" onSelect={loadView}>Transportation</NavItem>
        <NavItem key={"Lodging"} href="#" className="navitem-lodging" onSelect={loadView}>Lodging</NavItem>
        <NavItem key={"Schedule"} href="#" className="navitem-schedule" onSelect={loadView}>Schedule</NavItem>
        <NavItem key={"Bear Passes"} href="#" className="navitem-bearpasses" onSelect={loadView}>Bear Passes</NavItem>
        <NavItem key={"Sign Up"} href="#" className="navitem-signup" onSelect={loadView}>Sign Up</NavItem>
        <NavItem key={"Contact Us"} href="#" className="navitem-contactus" onSelect={loadView}>Contact Us</NavItem>
      </Nav>
    </Navbar>
  );


var menu = $('.menu')[0]
React.renderComponent(navbarInstance, menu);

console.log("finished mainMenu");
