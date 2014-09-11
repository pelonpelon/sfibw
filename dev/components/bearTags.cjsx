console.log "inside bearTags"

Grid = ReactBootstrap.Grid
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col

bearTags = (
  <Grid>
      <Row className="show-grid">
        <Col xs={12}><h4>{'Gold'}</h4></Col>
      </Row>
      <Row className="show-grid">
        <Col xs={12}><h4>{'Platinum'}</h4></Col>
      </Row>
      <Row className="show-grid">
        <Col xs={12}><h4>{'V.I.P.'}</h4></Col>
      </Row>
  </Grid>
)

React.renderComponent bearTags, $('.beartags .content')[0]
