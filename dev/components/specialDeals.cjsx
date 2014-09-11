console.log "inside bearTags"

TabbedArea = ReactBootstrap.TabbedArea
TabPane = ReactBootstrap.TabPane
Accordion = ReactBootstrap.Accordion
Panel = ReactBootstrap.Panel
Glyphicon = ReactBootstrap.Glyphicon
Label = ReactBootstrap.Label

specialDealsComponent = (

    <Panel className="mainPanel">
    <div className="notice">BearTag discounts in <strong>RED</strong></div>

    <TabbedArea defaultActiveKey={1} bsStyle={'pills'} animation={false}>
      <TabPane key={1} tab="Restaurants">

        <Accordion>
          <h3>SOMA</h3>
          <Panel header="Triptych" bsStyle={'danger'} key={1}>
            <img className="logo" src="https://triptych.cloudlgs.com/members/triptych/avatar/thumbs/thumbnail_1354826155.jpg" />
            <ul className="info">
              <li>20% off your meal<br />(except on Valentines Day)</li>
              <li><a href="http://www.triptychsf.com/index.php" target="_blank">Website</a></li>
              <li>Phone Number: {"415-703-0557"}</li>
            </ul>
          </Panel>
          <Panel header="Restaurant #2" key={2}>

          </Panel>
          <Panel header="Restaurant #3" key={3}>

          </Panel>
          <h3>CASTRO</h3>
          <Panel header="Restaurant #4" key={4}>

          </Panel>
          <Panel header="Restaurant #5" key={5}>

          </Panel>
        </Accordion>

      </TabPane>
      <TabPane key={2} tab="Hotels">

        <Accordion>
          <h3>SOMA</h3>
          <Panel header="Main Hotel" key={1}>
          </Panel>
          <Panel header="Hotel #2" key={2}>

          </Panel>
          <h3>CASTRO</h3>
          <Panel header="Hotel #3" key={3}>

          </Panel>
        </Accordion>

      </TabPane>
      <TabPane key={3} tab="Taxis">

        <Accordion>
          <h3>SOMA</h3>
          <Panel header="Homobile" key={1}>

          </Panel>
          <Panel header="\u00DCber" key={2}>

          </Panel>
          <h3>CASTRO</h3>
          <Panel header="Lyft" key={3}>

          </Panel>
        </Accordion>

      </TabPane>
      <TabPane key={4} tab="Events">

        <Accordion>
          <h3>SOMA</h3>
          <Panel header="Bearacuda" key={1}>

          </Panel>
          <Panel header="Event #2" key={2}>

          </Panel>
          <h3>CASTRO</h3>
          <Panel header="Event #3" key={3}>

          </Panel>
        </Accordion>

      </TabPane>
    </TabbedArea>
    </Panel>
)

React.renderComponent specialDealsComponent, $('.specialdeals .content')[0]
