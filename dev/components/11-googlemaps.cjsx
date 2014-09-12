InitGmap = (name)->

  el = $("."+name+"-gmap")[0]
  options = name+"Options"

  name = new google.maps.LatLng()
  options =
    center: name
    zoom: 8
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map el, options

ListenForGoogle = ->
  if window.google.maps?

    google.maps.event.addDomListener(window, 'load', InitGmap('triptych'))

# $.ajax
  # url: "https://maps.googleapis.com/maps/api/js?key=AIzaSyD8bNm6pzIcqUgTstR4iwwWtdPEFwL9Qv4&callback=ListenForGoogle"
  # dataType: "script"
