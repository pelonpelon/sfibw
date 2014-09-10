console.log "inside lodging"

Grid = ReactBootstrap.Grid
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col

lodgingComponent = (
  <Grid>
      <Row className="show-grid">
        <Col xs={6}><h4>{'Main Hotel'}</h4></Col>
        <Col xs={6}><h4>{'Becks'}</h4></Col>
      </Row>

      <Row className="show-grid">
        <Col xs={6}><h4>{'Best Western'}</h4></Col>
        <Col xs={6}><h4>{'Parker House'}</h4></Col>
      </Row>

  </Grid>
)

React.renderComponent lodgingComponent, $('.lodging .content')[0]
