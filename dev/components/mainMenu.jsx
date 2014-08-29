console.log("inside mainMenu");

var Nav = ReactBootstrap.Nav;
var Navbar = ReactBootstrap.Navbar;
var NavItem = ReactBootstrap.NavItem;
var renderedInstance;


function loadView (key) {
  $('.nav').find('.active').removeClass('active');
  navitem = ".navitem-"+key;
  $(navitem).addClass('active');
  var nt = $('.navbar-toggle');
  if ($('.in').is(":visible")){
    nt.click();
  }
  var view = "views/"+key+".html";
  $('.main .content').load(view);
}
function fadeContent () {
  $('.main .content').fadeToggle( "slow", "linear" );
}

var navbarInstance = (
    <Navbar
    toggleNavKey={"about"}
    fixedTop={true}
    inverse={false}
    fluid={true}
    onToggle={fadeContent}
    brand="sfBR">
      <Nav key={"about"} >
        <NavItem key={"about"} href="#jj" className="navitem-about" onSelect={loadView}>About</NavItem>
        <NavItem key={"transportation"} href="#" className="navitem-transportation" onSelect={loadView}>Transportation</NavItem>
        <NavItem key={"lodging"} href="#" className="navitem-lodging" onSelect={loadView}>Lodging</NavItem>
        <NavItem key={"schedule"} href="#" className="navitem-schedule" onSelect={loadView}>Schedule</NavItem>
        <NavItem key={"bearpasses"} href="#" className="navitem-bearpasses" onSelect={loadView}>Bear Passes</NavItem>
        <NavItem key={"signup"} href="#" className="navitem-signup" onSelect={loadView}>Sign Up</NavItem>
        <NavItem key={"contactus"} href="#" className="navitem-contactus" onSelect={loadView}>Contact Us</NavItem>
      </Nav>
    </Navbar>
  );


var menu = $('.menu')[0]
React.renderComponent(navbarInstance, menu);

console.log("finished mainMenu");
