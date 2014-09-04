console.log("inside mainMenu");

var Nav = ReactBootstrap.Nav;
var Navbar = ReactBootstrap.Navbar;
var NavItem = ReactBootstrap.NavItem;
var renderedInstance;
var currentKey;
var main = $('.main');
$('.main .content').addClass('animated');
var mainClickSurface = document.getElementsByClassName('main')[0];
/* FastClick.attach(document.body); */

function fadeContent () {

  var content = $('.main .content');
  var title = $('.navbar-title');
  var navbarClickSurface = document.getElementsByClassName('navbar')[0];

  if ($('.in').is(":visible")){
    console.log('in visible');
    content.removeClass('fadeIn fadeOut fadeDim');
    title.removeClass('fadeIn fadeOut fadeDim');
    content.addClass('fadeIn');
    title.addClass('fadeIn');
    /* FastClick.attach(mainClickSurface); */


  } else {
    console.log('not in visible');
    content.removeClass('fadeDim fadeIn fadeOut');
    title.removeClass('fadeDim fadeIn fadeOut');
    content.addClass('fadeDim');
    title.addClass('fadeDim');
    /* FastClick.attach(navbarClickSurface); */
  }

}

function loadView (key) {
  var nav = $('.collapse');

  if (currentKey == key){
    $('.navbar-toggle').click();
    return;
  }

  console.log("key: "+currentKey+" to "+key);
  currentKey = key;
  var content = $('.main .content');

  // Change title
  if ( $('.navbar-title').length ){
    var title = $('.navbar-title');
    title.removeClass('fadeIn fadeDim fadeOut');
    title.addClass('fadeOut').remove();
  }
  var brand = $('.navbar-brand');
  brand.after("<div class='navbar-title' style='opacity:0;'>"+key+"</div>");
  $('.navbar-title').addClass('animated fadeIn');

  // mark item as .active
  var items = $('.nav');
  items
    .find('.active')
    .removeClass('active');
  items
    .find(navitemClass)
    .addClass('active');

  // load new content
  var view = "views/"+key
              .toLowerCase()
              .split(' ')
              .join('')+".html";
  var navitemClass = ".navitem-"+key;
  content
    .removeClass('fadeIn fadeDim fadeOut')
    .addClass('fadeOut')
    .load(view)
    .removeClass('animated fadeOut');
  /* $('.collapse').slideUp().removeClass('in').css({'height': 0, 'display': 'block'}); */
  var toggleButton = $('.navbar-toggle');
  /* console.log(toggleButton); */
  /* content.addClass('animated fadeIn'); */
  /* console.log('about to click') */
  /* toggleButton.click(function(){ */
    /* console.log("this is"+this) */
  /* }); */
  console.log('loadView done')

}

function say () {
  alert('nav onSelect');
}

var navbarInstance = (
    <Navbar
      toggleNavKey={"about"}
      fixedTop={true}
      inverse={false}
      fluid={true}
      onToggle={fadeContent}
      brand={'<a href="http://sf-eagle.com/sfibw/lab/index.html">sfBR</a>'}
    >
      <Nav key={"about"} collapsable={true} expanded={false}>
        <NavItem key={"About"} hetef="#" className="navitem-about" onSelect={loadView}>About</NavItem>
        <NavItem key={"Transportation"} href="#" className="navitem-transportation" onSelect={loadView}>Transportation</NavItem>
        <NavItem key={"Lodging"} href="#" className="navitem-lodging" onSelect={loadView}>Lodging</NavItem>
        <NavItem key={"Schedule"} href="#" className="navitem-schedule" onSelect={loadView}>Schedule</NavItem>
        <NavItem key={"Bear Passes"} href="#" className="navitem-bearpasses" onSelect={loadView}>Bear Passes</NavItem>
        <NavItem key={"Sign Up"} href="#" className="navitem-signup" onSelect={loadView}>Sign Up</NavItem>
        <NavItem key={"Social"} href="#" className="navitem-social" onSelect={loadView}>Social</NavItem>
      </Nav>
    </Navbar>

  );


var mount = $('.menu')[0]
React.renderComponent(navbarInstance, mount);

console.log("finished mainMenu");
