/** @jsx React.DOM */

console.log("inside mainNav");

function handleSelect (selectedKey) {
  alert('selected ' + selectedKey);
}

var navInstance = (
    <Nav bsStyle="pills" activeKey={1} onSelect={handleSelect}>
      <NavItem key={1} href="/home">NavItem 1 content</NavItem>
      <NavItem key={2} title="Item">NavItem 2 content</NavItem>
      <NavItem key={3} disabled={true}>NavItem 3 content</NavItem>
    </Nav>
  );

main = $('.main');
header = main.find('.header');
console.log(header);
/* .text "this is other text" */
React.renderComponent(navInstance, header);

console.log("finished mainNav");

// vim: set:ft=jsx
