console.log("inside schedule")

Panel = ReactBootstrap.Panel
TabbedArea = ReactBootstrap.TabbedArea
TabPane = ReactBootstrap.TabPane

scrollTop = (key)->
  tabs = $('.nav-tabs')
  tabs
    .find('.active')
    .removeClass('active')
  tabs
    .find('[data-reactid$='+key+']')
    .addClass('active')
  panes = $('.tab-content')
  panes
    .find('.active')
    .removeClass('active')
  panes
    .find('.tab-pane.tab-'+key)
    .addClass('active in')
  window.scrollTo(0, 1)


key = 1

renderTabbedArea = ->
  scheduleComponent = (
      <TabbedArea defaultActiveKey={key} animation={false} onSelect={scrollTop}>
        <TabPane key={1} tab="Thursday 12" className="tab-1" animation={false}>

        <Panel header={<h3>Early Registration <span>@MainHotel</span></h3>}>
           <h4>5pm-9pm</h4>
        </Panel>

        <Panel header={<h3>Bear-a-oke <span>@SFEagle</span></h3>}>
          <h4>9pm-2am</h4>
        </Panel>

        </TabPane>
        <TabPane key={2} tab="Friday 13" className="tab-2">

        <Panel header={<h3>Registration <span>@MainHotel</span></h3>}>
          <h4>Noon-8pm</h4>
        </Panel>

        <Panel header={<h3>Happy Hour Castro Bar Crawl <span>@Castro</span></h3>}>
          <h4>5pm-8pm</h4>
          Mix, 440, Edge
        </Panel>

        <Panel header={<h3>Dance Party <span>@SOMA</span></h3>}>
          <h4>'til the wee hours</h4>
        </Panel>

        <Panel header={<h3>B Eros <span>@Eros</span></h3>}>
          <h4></h4>
        </Panel>

        </TabPane>
        <TabPane key={3} tab="Saturday 14" className="tab-3">

        <Panel header={<h3>Bear Brunch <span>@SFEagle</span></h3>}>
          <h4>10am-1pm</h4>
        </Panel>

        <Panel header={<h3>Bears, the Baths and Beyond <span>@Steamworks</span></h3>}>
          <h4>1pm-6pm</h4>
        </Panel>

        <Panel header={<h3>SF Bear Contest <span>@SFEagle</span></h3>}>
          <h4>3pm-6pm</h4>
          Polar Bear, Mr. Bear, Bear pig, Cub
        </Panel>

        <Panel header={<h3>Sister Bingo <span>@MainHotel</span></h3>}>
          <h4>7pm-10pm</h4>
        </Panel>

        <Panel header={<h3>BearCave Party <span>@Beatbox</span></h3>}>
          <h4>10pm-4am</h4>
        </Panel>

        </TabPane>
        <TabPane key={4} tab="Sunday 15" className="tab-4">

        <Panel header={<h3>SFBR Street Fair <span>@Harrison St.</span></h3>}>
          <h4>11am-6pm</h4>
        </Panel>

        <Panel header={<h3>Blow Your Bear <span>@BlowBuddies</span></h3>}>
          <h4>5pm</h4>
        </Panel>

        </TabPane>
        <TabPane key={5} tab="Monday 16" className="tab-5">

        <Panel header={<h3>BBQ and Beer Bust <span>@SFEagle</span></h3>}>
          <h4>3pm-6pm</h4>
        </Panel>

        <Panel header={<h3>Bear Necessities Castro Spree <span>@Castro</span></h3>}>
          <h4></h4>
        </Panel>

        </TabPane>
      </TabbedArea>
    )
  React.renderComponent(scheduleComponent, $('.schedule .content')[0])
  $('.nav-tabs>li:first-of-type').addClass 'active'

handleSelect = (selectedKey)->
  console.log 'selected ' + selectedKey
  key = selectedKey
  renderTabbedArea()

renderTabbedArea()

