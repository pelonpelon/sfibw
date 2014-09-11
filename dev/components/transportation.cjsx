console.log "inside transportation"

Grid = ReactBootstrap.Grid
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col

transportationComponent = (
  <Grid>
      <Row className="show-grid">
        <Col xs={6}><h4>{'Homobile'}</h4></Col>
        <Col xs={6}><h4>{'\u00DCber'}</h4></Col>
      </Row>

      <Row className="show-grid">
        <Col xs={6}><h4>{'Lyft'}</h4></Col>
        <Col xs={6}><h4>{'The Bear Bus'}</h4></Col>
      </Row>

  </Grid>
)

React.renderComponent transportationComponent, $('.transportation .content')[0]
