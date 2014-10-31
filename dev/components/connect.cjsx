console.log "inside connect"

Grid = ReactBootstrap.Grid
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input


connectComponent = (
  <Grid>
      <Row className="show-grid">
        <Col xs={4}>{<div className="icon email">Email</div>}</Col>
        <Col xs={4}>{<div className="icon facebook">Facebook</div>}</Col>
        <Col xs={4}>{<div className="icon twitter">Twitter</div>}</Col>
      </Row>

      <Row className="show-grid">
        <Col xs={4}>{<div className="icon googleplus">Google Plus</div>}</Col>
        <Col xs={4}>{<div className="icon instagram">Instagram</div>}</Col>
        <Col xs={4}>{<div className="icon tumblr">Tumblr</div>}</Col>
      </Row>

      <Row className="show-grid newsletter">
        <form>
          <Input type="static" value="
            Sign up for our NEWSLETTER to get the latest updates
            on BearTags, new events, hotel deals and more.
          " />
          <Input type="text" placeholder="Name" />
          <Input type="email" placeholder="Email address" />
          <input type="submit" defaultValue="Sign Up" />
        </form>
      </Row>

  </Grid>
)

React.renderComponent connectComponent, $('.connect .content')[0]
