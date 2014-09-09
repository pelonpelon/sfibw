console.log "inside lodging"

Grid = ReactBootstrap.Grid
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col

lodgingComponent = (
  <Grid>
      <Row className="show-grid">
        <Col xs={4}><h4>{'Email'}</h4></Col>
        <Col xs={4}><h4>{'Facebook'}</h4></Col>
        <Col xs={4}><h4>{'Twitter'}</h4></Col>
      </Row>

      <Row className="show-grid">
        <Col xs={4}><h4>{'Instagram'}</h4></Col>
        <Col xs={4}><h4>{'Tumblr'}</h4></Col>
        <Col xs={4}><h4>{'Newsletter'}</h4></Col>
      </Row>

  </Grid>
)

React.renderComponent lodgingComponent, $('.lodging .content')[0]
