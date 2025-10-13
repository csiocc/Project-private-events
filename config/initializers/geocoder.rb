Geocoder.configure(
  lookup: :nominatim,               # OpenStreetMap
  timeout: 5,
  units: :km,
  language: :de,
  http_headers: { "User-Agent" => "PrivateEventsApp (christian.siegrist@open-circle.ch)" }
)