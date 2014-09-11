console.log("inside schedule")

Panel = ReactBootstrap.Panel
TabbedArea = ReactBootstrap.TabbedArea
TabPane = ReactBootstrap.TabPane

key = 1

renderTabbedArea = ->
  scheduleComponent = (
      <TabbedArea defaultActiveKey={key} animation={false}>
        <TabPane key={1} tab="Thursday 12" animation={false}>

        <Panel header={<h3>Early Registration/MeetnGreet</h3>}>
           <h4>5pm-9pm</h4>
           Main Hotel
        </Panel>

        <Panel header={<h3>Bearaoke/Live Band Night</h3>}>
          <h4>9pm-2am</h4>
          at SF Eagle
        </Panel>

        </TabPane>
        <TabPane key={2} tab="Friday 13">

        <Panel header={<h3>Registration</h3>}>
          <h4>Noon-8pm</h4>
           Main Hotel
        </Panel>

        <Panel header={<h3>Happy Hour Castro Bar Crawl</h3>}>
          <h4>5pm-8pm</h4>
          Mix, 440, Edge
        </Panel>

        <Panel header={<h3>SOMA Dance Party</h3>}>
          <h4>'til the wee hours</h4>
        </Panel>

        <Panel header={<h3>B'Eros at Eros</h3>}>
          <h4></h4>
        </Panel>

        </TabPane>
        <TabPane key={3} tab="Saturday 14">

        <Panel header={<h3>Brunch at SF Eagle</h3>}>
          <h4>10am-1pm</h4>
        </Panel>

        <Panel header={<h3>Bears, the Baths and Beyond</h3>}>
          <h4>1pm-6pm</h4>
          Steamworks
        </Panel>

        <Panel header={<h3>SF Bear Contest</h3>}>
          <h4>3pm-6pm</h4>
          at SF Eagle
          Polar Bear, Mr. Bear, Bear pig, Cub
        </Panel>

        <Panel header={<h3>Sister Bingo</h3>}>
          <h4>7pm-10pm</h4>
          Main Hotel
        </Panel>

        <Panel header={<h3>Bearracuda</h3>}>
          <h4>10pm-4am</h4>
          at Beatbox
        </Panel>

        </TabPane>
        <TabPane key={4} tab="Sunday 15">

        <Panel header={<h3>Street Fair</h3>}>
          <h4>11am-6pm</h4>
        </Panel>

        <Panel header={<h3>Blow Your Bear</h3>}>
          <h4>5pm</h4>
          at Blow buddies
        </Panel>

        </TabPane>
        <TabPane key={5} tab="Monday 16">

        <Panel header={<h3>Wind down BBQ and Beer Bust</h3>}>
          <h4>3pm-6pm</h4>
          at SF Eagle
        </Panel>

        <Panel header={<h3>Castro retail romp</h3>}>
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

